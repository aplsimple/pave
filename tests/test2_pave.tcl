#! /usr/bin/env tclsh
# _______________________________________________________________________ #
#
# Test 2 demonstrates most features of apave package.
# Note how the pave is applied to the frames of notebook.
# _______________________________________________________________________ #

set tcltk_version "Tcl/Tk [package require Tk]"

# to get TCLLIBPATH variable when run from tclkit
if {[info exists ::env(TCLLIBPATH)]} {lappend ::auto_path {*}$::env(TCLLIBPATH)}

set ::testdirname [file normalize [file dirname [info script]]]
set ::pavedirname [file normalize [file join $::testdirname ..]]
cd $::testdirname
set ::test2dirs [list "$::testdirname/.." "$::testdirname" "$::testdirname/../bartabs" "$::testdirname/../hl_tcl" "$::testdirname/../../screenshooter" "$::testdirname/../../aloupe" "$::testdirname/../.bak/fsdialog" "$::testdirname/../.bak/tablelist"]
lappend ::auto_path {*}$::test2dirs
set apavever [package require apave]
set pkg_versions0 "\n  <red>apave $apavever</red>\n\n"
append pkg_versions0 "  <red>e_menu $apavever</red>\n\n"
append pkg_versions0 "  <red>bartabs [package require bartabs]</red>\n\n"
append pkg_versions0 "  <red>hl_tcl [package require hl_tcl]</red>\n\n"
append pkg_versions0 "  <red>baltip [package require baltip]</red>"
#package require fsdialog
set pkg_versions [string map {<red> "" </red> "" \n\n , \n ""} $pkg_versions0]
set ::e_menu_dir [file normalize [file join $::pavedirname ../e_menu]]
catch {source [file join $::e_menu_dir e_menu.tcl]}
catch {package require screenshooter}
catch {package require aloupe}
catch {source [file join $::pavedirname ../transpops/transpops.tcl]}

namespace eval t {

  variable ftx0 [file join $::testdirname [file tail [info script]]]
  variable ftx1 $ftx0
  variable ftx2 $ftx0
  variable ftx3 $ftx0
  # variables used in layouts
  variable v 1 v2 1 c1 0 c2 0 c3 0 en1 "" en2 "" tv 1 tv2 "enter value" sc 0 sc2 0 cb3 "Content of test2_fco.dat" lv1 {}
  variable fil1 "" fis1 "" dir1 "" clr1 "" fon1 "" dat1 ""
  variable ans0 0 ans1 0 ans2 0 ans3 0 ans4 0 fontsz 10
  variable lvar {white blue "dark red" black #112334 #fefefe
  "sea green" "hot pink" cyan aqua "olive drab" snow wheat  }
  variable arrayTab
  variable pdlg
  variable pave
  variable savedtext; array set savedtext [list]
  variable transpopsFile "transpops.txt"

# _________________ The code from Tk's demos/ttkpane.tcl ________________ #

  proc fillclock {w} {
    # Fill the clocks pane
    set i 0
    proc ::every {delay script} {
      uplevel #0 $script
      after $delay [list every $delay $script]
    }
    set testzones {
      :Europe/Berlin
      :America/Argentina/Buenos_Aires
      :Africa/Johannesburg
      :Europe/London
      :America/Los_Angeles
      :Europe/Moscow
      :America/New_York
      :Asia/Singapore
      :Australia/Sydney
      :Asia/Tokyo
    }
    # Force a pre-load of all the timezones needed; otherwise can end up
    # poor-looking synch problems!
    set zones {}
    foreach zone $testzones {
      if {![catch {clock format 0 -timezone $zone}]} {
        lappend zones $zone
      }
    }
    if {[llength $zones] < 2} { lappend zones -0200 :GMT :UTC +0200 }
    foreach zone $zones {
      set city [string map {_ " "} [regexp -inline {[^/]+$} $zone]]
      if {$i} {
        pack [ttk::separator $w.s$i] -fill x
      }
      ttk::label $w.l$i -text $city -anchor w
      ttk::label $w.t$i -textvariable time($zone) -anchor w
      pack $w.l$i $w.t$i -fill x
      every 1000 "set time($zone) \[clock format \[clock seconds\] -timezone $zone -format %T\]"
      incr i
    }
  }

# ________________ Handlers for Help, Apply, Cancel etc. ________________ #

  # imitating help function
  proc helpAbout {} {
    ::t::msg info "  It's a demo of
    $::pkg_versions0\n\n  Details: \

   \u2022 <link1>aplsimple.github.io/en/tcl/pave</link1>
   \u2022 <link1>aplsimple.github.io/en/tcl/e_menu</link1>
   \u2022 <link1>aplsimple.github.io/en/tcl/bartabs</link1>
   \u2022 Reference on <link2>hl_tcl</link2>
   \u2022 Reference on <link2>baltip</link2>

  License: <linkMIT>MIT</linkMIT>
  _____________________________________

  <red> $::tcltk_version </red> <link3></link3>

  <red> $::tcl_platform(os) $::tcl_platform(osVersion) </red>\n
" -modal no -t 1 -w 41 -scroll 0 -tags ::t::textTags -my "after idle {::t::textImaged %w}"
  }

  # imitating apply function
  proc applyProc {} {
    if {$t::ans1<10} {
      set t::ans1 [lindex [pdlg ok info "APPLY" "\nApplying changes...\nSee results in the terminal.\n" \
        -ch "Don't show again"] 0]
    }
    putsResult2
  }

  # end with the test
  proc endTest {} {
    ::apave::endWM
    pave res .win 0
  }

  # imitating cancel function
  proc cancelProc {} {
    if {$t::ans2<10} {
      set t::ans2 [lindex [pdlg yesnocancel warn "CANCEL" \
        "\nDiscard all changes?\n" NO -ch "Don't show again"] 0]
      if {$t::ans2==1 || $t::ans2==11} {
        endTest
      }
    }
  }

  # imitating save & exit function
  proc okProc {} {
    ::t::pdlg ok info "SAVE" "Finita la commedia.\nCurtain." -weight bold -size 16
    pave res .win 1
  }

  proc restartHint {cs} {
    return "\nRestart with:\n    theme = \"$::t::opct\"\n    CS = \"$::t::opcc\"\n    font size = $::t::fontsz\n?\n\nIt's a good choice, as GUI would be properly set up.\n"
  }

  # imitating the toolbar functions
  proc toolBut {num {cs -2} {starting no} {hl yes}} {
    if {$num in {3 4}} {
      #[pave Menu] entryconfigure 2 -font {-slant roman -size 10}
    } elseif {$num == 2} {
      [pave Pro] stop
      [pave BuT_IMG_2] configure -state disabled
      [pave BuT_IMG_1] configure -state normal
    } elseif {$num == 1} {
      [pave Pro] start
      [pave BuT_IMG_1] configure -state disabled
      [pave BuT_IMG_2] configure -state normal
    }
    [pave File] entryconfig 2 -state [[pave BuT_IMG_2] cget -state] ;# for fun
    [pave File] entryconfig 3 -state [[pave BuT_IMG_2] cget -state]
    set forfun "For fun only:
       It's disabled by 'Stop progress' button
       shown as \[x\] in the toolbar below."
    baltip::tip [pave File] $forfun -index 2
    baltip::tip [pave File] $forfun -index 3

    if {$num in {3 4}} {
      if {$num == 3} {set cs $::t::prevcs}
      if {$num == 4 && $cs==-3} {
        if {[set cs [::t::csCurrent]]<[apave::cs_Min]} {set cs [apave::cs_Min]}
        pave basicFontSize $::t::fontsz
      }
      set ic [expr {$cs>22 ? 3 : 2}]  ;# "|" was added
      set ::t::opcc [pave optionCascadeText [lindex $::t::opcColors $cs+$ic]]
      if {!$starting && $::t::restart} {
        if {$t::ans4<10} {
          set t::ans4 [lindex [::t::pdlg yesnocancel warn "RESTART" \
            [restartHint $cs] NO -ch "Don't show again"] 0]
        }
        if {$t::ans4==1 || $t::ans4==11} {
          pave res .win [set ::t::newCS $cs]
          return
        }
        if {!$t::ans4} return
      }
      pave csSet $cs . -doit
      if {$cs>[apave::cs_Min]} {
        set ::t::prevcs [expr {$cs-1}]
      } else {
        set ::t::prevcs [apave::cs_MaxBasic]
      }
      if {$cs<[apave::cs_MaxBasic]} {
        set ::t::nextcs [expr {$cs+1}]
      } else {
        set ::t::nextcs [apave::cs_Min]
      }
      .win.fra.fra.nbk tab .win.fra.fra.nbk.f5 -text \
      " Color scheme [pave csGetName $cs]"
      if {$::t::hue !=0} hueUpdate
      catch {::t::colorBar; ::bt draw}
      pave fillGutter [pave Text]
    }
#    baltip::tip [pave BuT_IMG_4] \
#      "Next is $::t::nextcs: [pave csGetName $::t::nextcs]" -under 5
#    baltip::tip [pave BuT_IMG_3] \
#      "Previous is $::t::prevcs: [pave csGetName $::t::prevcs]" -under 5
    lassign [pave csGet] fg - bg - - bS fS
    set ::t::textTags [list \
      [list "red" " -font {-weight bold} -foreground $fS -background $bS"] \
      [list "link1" "::apave::openDoc %t@@https://%l@@"] \
      [list "link2" "::apave::openDoc %t@@https://aplsimple.github.io/en/tcl/%l/%l.html@@"] \
      [list "link3" "::apave::openDoc %t@@https://wiki.tcl-lang.org@@"] \
      [list "linkMIT" "::apave::openDoc %t@@https://en.wikipedia.org/wiki/MIT_License@@"] \
      ]
    if {$t::ans4==12} {
      set ::t::restart 0
      [pave ChbRestart] configure -state disabled
    }
    if {$hl} {
      bartabs::drawAll
      ::hl_tcl::hl_all -dark [pave csDarkEdit] -font [pave csFontMono]
    }
    after idle "
      if {[::t::csCurrent]==-2} {
        [::t::pave Spx_Hue] configure -state disabled
      } else {
        [::t::pave Spx_Hue] configure -state normal
      }
      if {$::t::restart} {
        [::t::pave Spx_FS] configure -state disabled
      } else {
        [::t::pave Spx_FS] configure -state normal
      }
    "
  }

  # ask about exiting
  proc exitProc {resExit} {
    upvar $resExit res
    if {[::t::pdlg yesno ques "EXIT" "\nClose the test?\n" NO]==1} {
      set res 0
      ::apave::endWM
    }
  }

  # changing the current tab: we need to save the old tab's selection
  # in order to restore the selection at the tab's return.
  proc chanTab {tab {nt ""} {doit no} {dotip no}} {
    if {$tab != $::t::curTab || $doit} {
      if {$::t::curTab !=""} {
        set arrayTab($::t::curTab) [.win.fra.fra.$::t::curTab select]
        pack forget .win.fra.fra.$::t::curTab
      }
      set ::t::curTab $tab
      pack .win.fra.fra.$::t::curTab -expand yes -fill both
      catch {
        if {$nt eq ""} {set nt $arrayTab($::t::curTab)}
        .win.fra.fra.$::t::curTab select $nt
        if {$dotip} {
          lassign [split [winfo geometry .win] x+] w h x y
          set geo "+([expr {$w+$x}]-W-8)+$y-20"
          if {[::apave::obj csDarkEdit]} {
            set fg black
            set bg yellow
          } else {
            set fg white
            set bg black
          }
          ::baltip tip .win "The tab is selected by your request: \
            \n\"[.win.fra.fra.$::t::curTab tab $nt -text]\"" \
            -geometry $geo -fg $fg -bg $bg -font {-weight bold -size 11} \
            -pause 1500 -fade 1500 -alpha 0.8 -padx 20 -pady 20
        }
      }
    }
  }

  # check the value to avoid the infinite cycles of redrawing
  proc fontszCheck {} {
    catch {after cancel $::afters}
    set ::afters [after 100 {::t::toolBut 4 -3}]
  }

  # check the value to avoid the infinite cycles of redrawing
  proc hueCheck {} {
    catch {after cancel $::afters}
    set ::afters [after 100 {
      ::t::hueUpdate
      ::t::toolBut 0
    }]
  }

  # update the hue
  proc hueUpdate {} {
    if {[set cs [::t::csCurrent]] ==-2} return
    pave csToned $cs [expr {$::t::hue*5}]  ;# the hue is changed by 5% step
    puts "\nNew hues of \"$::t::opcc\" in CS-[pave csCurrent]:\n[pave csGet]"
  }

  # Gets "real" (not toned) color scheme
  proc csCurrent {} {
    if {[set cs [scan $::t::opcc %d:]] eq "{}"} {set cs -2}
    return $cs
  }

  # displaying the cursor position and the current line's contents
  proc textPos {txt args} {
    lassign [split [$txt index insert] .] r c
    [pave Labstat1] configure -text $r
    [pave Labstat2] configure -text [incr c]
  }

  # filling the menu
  proc fillMenu {} {
    set m .win.menu.file
    $m add command -label "Open..." -command {::t::msg info "This is just a demo:\nno action has been defined for the \"Open...\" entry."}
    $m add command -label "New" -command {::t::msg info "This is just a demo:\nno action has been defined for the \"New\" entry."}
    $m add command -label "Save" -command {::t::msg info "This is just a demo:\nno action has been defined for the \"Save\" entry."}
    $m add command -label "Save As..." -command {::t::msg info "This is just a demo:\nno action has been defined for the \"Save As...\" entry."}
    $m add separator
    if {$::noRestart} {set state disabled} {set state normal}
    $m add command -label "Restart" -command {::t::restartit} -state $state
    $m add separator
    $m add command -label "Quit" -command {::t::endTest}
    set m .win.menu.edit
    $m add command -label "Cut" -command {::t::msg ques "This is just a demo: no action."}
    $m add command -label "Copy" -command {::t::msg warn "This is just a demo: no action."}
    $m add command -label "Paste" -command {::t::msg err "This is just a demo: no action."}
    $m add separator
    $m add command -label "Find..." -command {::t::findTclFirst yes} -accelerator Ctrl+F
    $m add command -label "Find Next" -command {::t::findTclNext yes} -accelerator F3
    $m add separator
    $m add command -label "Reload the bar of tabs" -command {::t::RefillBar}
    set m .win.menu.help
    $m add command -label "About" -command ::t::helpAbout
  }

  proc textImaged {w} {
    pave labelFlashing [pave textLink $w 6] "" 1 \
      -file [file join $::testdirname feather.png] -pause 0.5 -incr 0.1 -after 40
  }

  proc textIco {w ico} {
    pave labelFlashing [pave textLink $w 0] "" 1 \
      -data [::apave::iconData $ico] -static 1
  }

  proc tracer {varname args} {
    set ::t::sc2 [expr round($::t::sc)]
  }

  proc viewfile {} {
    set res [::t::pdlg vieweditFile test2_fco.dat "" -w 74 -h 20 -ro 0 -rotext ::temp]
    puts "\n------------\nResult: $res.\nContent:\n$::temp\n------------\n"
    unset ::temp
  }

  proc Pressed {} {
    if {[[::t::pave BuTRun] cget -text]!="button"} return
    set bg [[::t::pave BuTRun] cget -background]
    [::t::pave BuTRun] config -text "P R E S S E D"
    for {set i 0} {$i<700} {incr i 100} {
      after $i {[::t::pave BuTRun] config -background #292a2a}
      after [expr $i+50] "[::t::pave BuTRun] config -background $bg"
    }
    after 800 [list [::t::pave BuTRun] config -text button]
  }

  proc TextConfigPie {} {
    ##################################################################
    # This code is taken from Tk's demos/ctext.tcl
    proc mkTextConfigPie {w x y i0 a option value color} {
      set arcid [$w create arc $x $y [expr {$x+90}] [expr {$y+90}] \
        -start [expr {$a-15}] -extent 30 -fill $color]
      $w addtag ArcTag[incr i0] withtag $arcid
      ::baltip::tip $w "This is an $i0-th arc\nwith tag 'ArcTag$i0'" -ctag ArcTag$i0
    }
    set c .win.fra.fra.nbk.f4.can
    set txtid [$c create text 180 20 -text {Demo canvas from Tk's demos/ctext.tcl} -fill red]
    $c addtag TextTag withtag $txtid
    ::baltip::tip $c "This is a text\nwith tag 'TextTag'" -ctag TextTag
    for {set i0 0} {$i0<12} {incr i0} {
      set i1 [expr {$i0*30}]
      set i2 [expr {$i0>9 ? [expr {($i0-10)*30}]: [expr {90+$i1}]}]
      mkTextConfigPie $c 140 30 $i0 $i1 -angle  $i2 Yellow
    }
  }

  proc msg {icon message args} {
    ::t::pdlg ok $icon [string toupper $icon] "\n$message\n" {*}$args
  }

  proc restartit {} {
    if {[set cs [::t::csCurrent]]==[apave::cs_Non]} {set cs [apave::cs_Min]}
    if {[::t::pdlg yesno warn "RESTART" [restartHint $cs]]} {
      ::apave::endWM
      pave res .win [set ::t::newCS $cs]
    }
  }

  proc goWiki {} {
    set who [string map {" " "+"} [[pave LabImgInfo] cget -text]]
    ::apave::openDoc "https://en.wikipedia.org/w/index.php?cirrusUserTesting=classic-explorer-i&search=$who"
  }

  proc labelImaged {} {
    foreach f {1 2 3 4} {append files [file join $::testdirname $f-small.png] " "}
    pave labelFlashing [pave LabImg] [pave LabImgInfo] 1 -file $files \
      -label {"Cisticola exilis" "Titmouse" "Wheatear" "Eurasian wren"} \
      ;# -squeeze 2
  }

  proc findTclFirst {{dochan no}} {
    set ent [pave EntFind]
    set tex [pave Text]
    chanTab nbk .win.fra.fra.nbk.f2 $dochan
    set err [catch {$tex tag ranges sel} sel]
    if {!$err && [llength $sel]==2} {
      $ent delete 0 end
      $ent insert 0 [$tex get {*}$sel]
    }
    pack [pave FraFind]
    $ent selection range 0 end
    focus $ent
    set closefind "pack forget [::t::pave FraFind]; focus $tex; break"
    foreach k {<Return> <KP_Enter>} {
      bind $ent $k "::t::pave findInText 0 $tex ::t::Find; $closefind"
    }
    foreach k {<Escape> <FocusOut>} {bind $ent $k $closefind}
  }

  proc findTclNext {{dochan no}} {
    chanTab nbk .win.fra.fra.nbk.f2 $dochan
    pave findInText 1 [pave Text] ::t::Find
  }

  proc screenshooter {} {
    if {[catch {
      if {[info exists ::winshot]} {
        $::winshot display
      } else {
        set ::winshot [screenshooter::screenshot .win.sshooter \
          -background LightYellow -foreground Green]
      }
    } e]} {
      ::t::pdlg ok err ERROR "\n ERROR:\n $e\n\n Install screenshooter in ../screenshooter directory.\n\n See you at https://aplsimple.github.io\n" -t 1
    }
  }

  proc aloupe {} {
    if {[catch {::aloupe::run -exit no -ontop yes -command {puts color:%c} -parent .win} e]} {
      ::t::pdlg ok err ERROR "\n ERROR:\n $e\n\n Install aloupe in ../aloupe directory.\n\n See you at https://aplsimple.github.io\n" -t 1
    }
  }

  proc e_menu {{fname ""}} {
    if {[info commands ::em::main] ne ""} {
      if {$fname eq ""} {set fname $::t::ftx1}
      set geo "240x1+"
      if {[::em::exists]} {
        lassign [split [::em::geometry] x+] w h x y
        append geo "$x+$y"
      } else {
        lassign [split [winfo geometry .win] x+] w h x y
        lassign [split [winfo geometry [pave ButHome]] x+] w2 h2
        append geo "[expr {$w+$x-250}]+[expr {$y+$h2*2}]"
      }
      set cs [pave csCurrent]
      set seltxt [pave selectedWordText [pave Text]]
      ::em::main -prior 1 -modal 0 -remain 0 "md=~/.tke/plugins/e_menu/menus" m=menu.mnu "f=$fname" "PD=~/PG/e_menu_PD.txt" "s=$seltxt" b=chromium h=~/DOC/www.tcl.tk/man/tcl8.6 "tt=xterm -fs 12 -geometry 90x30+400+100" g=$geo om=0 c=$cs o=0 t=1
      set cs2 [::t::csCurrent]
      if {$cs!=$cs2} {toolBut 4 $cs2}
    } else {
      ::t::pdlg ok err ERROR "\n Not found e_menu.tcl in directory:\n $::e_menu_dir\n" -t 1
    }
  }

# ________________ Handlers for tk_optionCascade widget _________________ #

  proc opcPre {args} {
    lassign $args a
    if {$a in {yellow magenta cyan} || ![string first # $a]} {
      return "-background $a -activeforeground $a"
    } else {
      return ""
    }
  }

  proc opcPost {} {
    set fg [ttk::style lookup TButton -foreground]
    set bg [ttk::style lookup TButton -background]
    set fga [ttk::style lookup TButton -foreground focus]
    set bga [ttk::style lookup TButton -background focus]
    if {$::t::opcvar in {yellow magenta cyan} || ![string first # $::t::opcvar]} {
      ttk::style configure TMenubutton -background $::t::opcvar
    } else {
      ttk::style configure TMenubutton -background $bg
    }
    ttk::style configure TMenubutton -foreground $fg
    ttk::style map TMenubutton \
      -background  [list pressed $bg active $bga] \
      -foreground  [list pressed $fg active $fga]
    puts "::t::opcvar = $::t::opcvar"
  }

  proc opcToolPre {args} {
    lassign $args a
    set a [string trim $a ":"]
    if {[string is integer $a]} {
      lassign [pave csGet $a] - fg - bg
      return "-background $bg -foreground $fg"
    } else {
      return ""
    }
  }

  proc opcToolPost {} {
    ttk::style theme use $::t::opct
    toolBut 4 [::t::csCurrent]
  }

  proc opcIconSetPost {} {
    if {$::t::restart} {
      set ::t::newCS [::t::csCurrent]
      pave res .win 100
    }
  }

  proc highlighting_editor {} {
    set TID [::bt cget -tabcurrent]
    ::hl_tcl::hl_init [pave Text] -seen 500 -dark [pave csDarkEdit] -cmdpos ::t::textPos \
      -readonly [getLock $TID] -font [pave csFontMono] -multiline $::multiline
    ::hl_tcl::hl_text [pave Text]
  }

  proc highlighting_others {{ro 1}} {

    # try to get "universal" highlighting colors (for dark&light bg):
    ::hl_tcl::hl_init [pave TextNT] -dark [pave csDarkEdit] \
      -seen 100 -readonly $ro -font [pave csFontMono] \
      -colors {"#BC47D9" #AB21CE #0C860C #9a5465 #66a396 brown #7150cb}
    ::hl_tcl::hl_text [pave TextNT]
    ::t::pave makePopup [pave TextNT] $ro yes
    set lab [[pave LaBNT] cget -text]
    if {$ro} {
      [pave LaBNT] configure -text [string map {editable read-only} $lab]
      set ::t::v2 1
    } else {
      [pave LaBNT] configure -text [string map {read-only editable} $lab]
      set ::t::v2 2
    }
  }

# ____________________ Procedures for bartabs widget ____________________ #

  # filling the bar of tabs
  proc fillBarTabs {wframe {swredraw false}} {
    if {![info exists ::BTS_REDRAW]} {set ::BTS_REDRAW 1}
    if {$swredraw} {set ::BTS_REDRAW [expr {[incr ::BTS_REDRAW]%2}]}
    set ::t::noname "<No name>"
    set ::t::ansSelTab [set ::t::ansSwBta 0]
    set wbase [pave LfrB]
    set bar1Opts [list -wbar $wframe -wbase $wbase -lablen 16 -tiplen 20 \
      -csel {::t::selTab %t} -csel2 {::t::selTab2 %t} -bd 1 -expand 1 \
      -cdel {::t::delTab %t} -redraw $::BTS_REDRAW -popuptip ::t::popupTip \
      -menu [list \
      sep \
      "com {Mark the tab} {::t::markTab %t} {} ::t::checkMark" \
      "com {Lock %l} {::t::lockUnlock %t} {} ::t::checkLock" \
      "com {Append $::t::noname} {::t::addTab %t} {} ::t::checkStatic" \
      "com {View selected} {::t::ViewSelTabs %b} {} {{!\[::bt isTab %t\]} ICN19-small}" \
      {com {Unselect all} {::bt unselectTab} {} {{![::bt isTab %t]}}} \
      sep \
      {com {Run %l} {::t::e_menu [::t::getTabFile %t]} {} {{![::bt isTab %t]} ICN13-small {} F5}} \
      sep \
      "mnu {Options} {} menusw {0 ICN22-small}" \
      "com {Switch ::multiline option} {::t::switchBts %b %t ::multiline} menusw ::t::switchAtt" \
      "com {Switch -static option} {::t::switchBts %b %t -static} menusw ::t::switchAtt" \
      "com {Switch -scrollsel option} {::t::switchBts %b %t -scrollsel} menusw ::t::switchAtt" \
      "com {Switch -hidearrows option} {::t::switchBts %b %t -hidearrows} menusw ::t::switchAtt" \
      "com {Switch -expand option} {::t::switchBts %b %t -expand} menusw ::t::switchAtt" \
      "com {Switch -bd option} {::t::switchBts %b %t -bd} menusw ::t::switchAtt" \
      "sep {} {} menusw" \
      "mnu {Others} {} menusw.oth" \
      "com {Switch -redraw option} {::t::RefillBar yes} menusw.oth ::t::switchAtt" \
      "com {Switch -fgsel option} {::t::switchBts %b %t -fgsel} menusw.oth ::t::switchAtt" \
      "com {Switch -imagemark option} {::t::switchBts %b %t -imagemark} menusw.oth ::t::switchAtt" \
      "com {Switch -lablen option} {::t::switchBts %b %t -lablen} menusw.oth ::t::switchAtt" \
      "sep {} {} menusw.oth" \
      "com {Switch -lowlist option} {::t::switchBts %b %t -lowlist} menusw.oth ::t::switchAtt" \
      "com {Switch -tiplen option} {::t::switchBts %b %t -tiplen} menusw.oth ::t::switchAtt" \
      "sep {} {} menusw.oth" \
      "com {Switch -padx} {::t::switchBts %b %t -padx} menusw.oth ::t::switchAtt" \
      "com {Switch -pady} {::t::switchBts %b %t -pady} menusw.oth ::t::switchAtt" \
      ]]
    set ::t::tclfiles [list]
    foreach dirname $::test2dirs {
      if {![catch {set files [glob [file join $dirname *.tcl]]}]} {
        foreach f $files {
          set f [file normalize $f]
          set fname [file tail $f]
          if {[lsearch -index 0 $::t::tclfiles $fname]>-1} {
            set fname [file join {*}[lrange [file split $f] end-1 end]]
          }
          lappend ::t::tclfiles [list $fname $f]
        }
      }
    }
    foreach ff [set ::t::tclfiles [lsort -index 0 $::t::tclfiles]] {
      set tab [lindex $ff 0]
      if {[string match "bart*" $tab]} {
        lappend bar1Opts -imagetab [list $tab ICN69-small]
      } else {
        lappend bar1Opts -tab $tab
      }
    }
    bartabs::Bars create ::bts                ;# ::bts is Bars object
    set ::t::BID [::bts create ::bt $bar1Opts [file tail $::t::ftx1]]
    foreach tab [::bt listTab] ffil $::t::tclfiles {
      ::bt [lindex $tab 0] configure -tip [lindex $ffil 1]
    }
    bind [pave Text] <Control-Left> "::bt scrollLeft ; break"
    bind [pave Text] <Control-Right> "::bt scrollRight ; break"
    bind .win <F5> "::t::e_menu; break"
    colorBar
  }

  proc popupTip {wmenu idx TID} {
    catch {::baltip tip $wmenu [getTabFile $TID] -index $idx}
  }

  proc colorBar {} {
    set cs [pave csCurrent]
    if {$cs>-1} {
      lassign [pave csGet $cs] cfg2 cfg1 cbg2 cbg1 cfhh - - - - fgmark
    } else {
      set fgmark #800080
    }
    ::bt configure -fgmark $fgmark
  }

  proc getTabFile {TID} {
    set label [::bts $TID cget -text]
    set i [lsearch -index 0 $::t::tclfiles $label]
    return [lindex $::t::tclfiles $i 1]
  }

  proc selTab {TID} {
    set tcurr [::bt cget -tabcurrent]
    set text [[pave Text] get 1.0 end]
    set text [string trimright [[pave Text] get 1.0 end] \n]
    if {$text ne ""} {append text \n}
    set ::t::savedtext($tcurr,text) $text
    set ::t::savedtext($tcurr,pos) [[pave Text] index insert]
    if {$tcurr in [::bt cget -mark] && $::t::ansSelTab<10} {
      set fname [getTabFile $tcurr]
      set ::t::ansSelTab [msg warn "The file $fname was modified (marked).\nThere might be some actions taken before quitting it.\n\nThe text buffer is one for all files, thus no saved undo/redo after quitting it.\nIt's a detail of implementation specific for this test." -ch "Don't show again" -modal 0]
    }
    set ::t::ftx1 [getTabFile $TID]
    if {[catch {set ::t::filetxt $::t::savedtext($TID,text)}]} {
      set ::t::filetxt [::apave::readTextFile $::t::ftx1]
    }
    [pave LabEdit] configure -text "$::t::ftx1" -padding {2 8 0 2}
    return yes
  }

  proc selTab2 {TID} {
    set monf "Noto Sans Mono"
    if {$monf in [font families]} {set monf " -family {$monf}"} {set monf ""}
    ::hl_tcl::hl_init [pave Text] -dark [pave csDarkEdit] -font \
      "[pave csFontMono]$monf"
    if {[catch {set pos $::t::savedtext($TID,pos)}]} {set pos 1.0}
    pave displayText [pave Text] $::t::filetxt $pos
    highlighting_editor
  }

  proc delTab {TID} {
    set fname [getTabFile $TID]
    ;# just to play with BID (::bt is less wordy):
    set BID [::bts $TID cget -BID]
    if {$TID in [::bts $BID cget -mark]} {
      msg warn "The file $fname was modified (marked).\nThere might be some actions taken before its closing.\n\nThe test is just rejecting the closing. Press Ctrl+Z to undo or\nchoose \"Unmark\" from the popup menu, then close the file."
      return no
    }
    return yes
  }

  proc tabModified {} {
    ;# just to play with ::t::BID (::bt is less wordy):
    if {[info exists ::t::BID]} {
      set tcurr [::bts $::t::BID cget -tabcurrent]
      if {[::bts isTab $tcurr]} {
        if {[[pave Text] edit modified]} {
          ::bts markTab $tcurr
        } else {
          ::bts unmarkTab $tcurr
        }
      }
    }
  }

  proc addTab {TID} {
    set newTID [::bt insertTab $::t::noname end ICN29-small]
    if {$newTID==""} {
      set newTID [::bt tabID $::t::noname]
      if {$newTID==""} {
        msg err "\n Tab not created."
        return
      }
    }
    lappend ::t::tclfiles [list $::t::noname $::t::noname]
    ::bts $newTID show
  }

  proc checkStatic {args} {
    if {[::bt cget -static]} {return 2}
    return {0 ICN29-small}
  }

  proc checkMark {BID TID label} {
    if {[::bt cget -static]} {return 2}
    set res [checkStatic]
    if {$TID in [::bt cget -mark]} {
      set label [string map {Mark Unmark} $label]
      set img ""
    } else {
      set label [string map {Unmark Mark} $label]
      set img ICN59-small
    }
    return [list [expr {![::bt isTab $TID]}] $img $label]
  }

  proc markTab {TID} {
    if {$TID in [::bt cget -mark]} {
      ::bts unmarkTab $TID
    } else {
      ::bts markTab $TID
    }
  }

  proc getLock {TID} {
    return [expr {[::bt $TID cget -lock] ne ""}]
  }

  proc setLock {TID} {
    ::hl_tcl::hl_readonly [pave Text] [getLock $TID] ;#::t::meStub
  }

  proc checkLock {BID TID label} {
    if {[getLock $TID]} {
      set label [string map {Lock Unlock} $label]
      set img ICN49-small
    } else {
      set label [string map {Unlock Lock} $label]
      set img ICN48-small
    }
    return [list 0 $img $label]
  }

  proc lockUnlock {TID} {
    if {[::bt $TID cget -lock] ne ""} {
      ::bt $TID configure -lock ""
    } else {
      ::bt $TID configure -lock "1"
    }
    if {$TID == [::bts $::t::BID cget -tabcurrent]} {
      setLock $TID
    }
  }

  proc switchAtt {BID TID label} {
    lassign $label -> opt
    switch -- $opt {
       ::multiline {
         if {$::multiline} {set img ICN27-small} {set img ICN28-small}
         set res [list 0 $img]
      }
      -static - -scrollsel - -hidearrows - -expand - -bd - -redraw - -lowlist {
        if {[::bt cget $opt]} {set img ICN27-small} {set img ICN28-small}
        set res [list 0 $img]
      }
      -lablen - -tiplen - -fgsel - -pady - -padx {
        set val [::bt cget $opt]
        set res [list 0 "" "$label ($val)"]
      }
      -imagemark {
        if {[::bt cget -static]} {return 2}
        if {[::bt cget $opt] eq ""} {set img ""} {set img ICN59-small}
        set res [list 0 $img]
      }
      default {set res 0}
    }
    return $res
  }

  proc switchBts {BID TID optname args} {
    set val [::bt cget $optname]
    switch -- $optname {
      ::multiline {
        set ::multiline [expr {!$::multiline}]
        highlighting_editor
        return
      }
      -bd     {if {!$val} {set val 1} {set val 0}}
      -lablen - -tiplen {if {!$val} {set val 16} {set val 0}}
      -fgsel  {if {$val eq ""} {set val "."} {set val ""}}
      -pady - -padx {if {$val==10} {set val 3} {set val 10}}
      -imagemark {if {$val eq ""} {set val ICN59-small} {set val ""}}
      default {if {[expr {$val eq "" || !$val}]} {set val yes} {set val no}}
    }
    ::bt configure $optname $val
    if {$optname ne "-scrollsel"} {
      ::bt clear
      ::bt draw
    }
    set bwidth [::bt cget -width]
    set twidth [::bts $TID cget -width]
    if {$::t::ansSwBta<10} {
      set ::t::ansSwBta [msg info "The \"$optname\" option is \"$val\".\n\n$BID's width is $bwidth.\n$TID's width is $twidth." -ch "Don't show again"]
    }
  }

  proc ViewSelTabs {BID} {
    set sellist ""
    set fewsel [::bt $BID listFlag "s"]
    set tcurr [::bt $BID cget -tabcurrent]
    foreach TID $fewsel {
      set text [::bts $TID cget -text]
      append sellist " TID: $TID, label: $text\n"
    }
    if {$sellist eq ""} {set sellist " None\n"}
    set text [::bts $tcurr cget -text]
    msg info " Selected tabs:\n$sellist \
      \n Current tab: TID: $tcurr, label: $text\n\n Click on a tab while pressing Ctrl to select few tabs." -text 1
  }

  proc RefillBar {{swredraw false}} {
    ::bts destroy
    fillBarTabs [pave BtsBar] $swredraw
    if {![info exists ::t::ansNewBar] || $::t::ansNewBar<10} {
      set ::t::ansNewBar [msg info \
        "New bar ID: $::t::BID.\nCurrent file: \"[file tail $::t::ftx1]\".\
        \n\nWhile editing, use Ctrl+Left and Ctrl+Right to scroll files." \
        -ch "Don't show again"]
    }
    highlighting_others
  }

  proc putsResult1 {} {
    puts " \n      \
      text file name = \"$::t::ftx1\" \n      \
      text file contents = \n   \
  ------------------------------- \n   \
  \n[pave getTextContent ::t::ftx1] \n\n   \
  ------------------------------- \n\n"
  }

  proc putsResult2 {} {
    puts " \n      \
      v   = $t::v \n      \
      v2  = $t::v2 \n      \
      c1  = $t::c1 \n      \
      c2  = $t::c2 \n      \
      c3  = $t::c3 \n      \
      cb3 = \"$t::cb3\" \n      \
      en1 = \"$t::en1\" \n      \
      en2 = \"$t::en2\" \n      \
      fil1= \"$t::fil1\" \n      \
      fis1= \"$t::fis1\" \n      \
      dir1= \"$t::dir1\" \n      \
      fon1= \"$t::fon1\" \n      \
      clr1= $t::clr1 \n      \
      dat1= $t::dat1 \n      \
    "
  }

  proc putsResult3 {} {
    puts " \n      \
      lvar ALL: $t::lvar \n      \
   \n      \
      lv1 ALL: $t::lv1 \n      \
   \n      \
      tblWid1 curselection: [lindex $::t::tbllist 0] \n      \
      tblWid1 curitem     : [lindex $::t::tbllist 1] \n      \
      tblWid1 items       : [lindex $::t::tbllist 2] \n      \
    "
    puts "Days selected: [klnd::getDaylist $::t::paveobj]"
  }

# __________________________ Paving procedures __________________________ #

  proc pave_Main_Frame {} {

    return {
      {frat - - 1 20 {-st we} }
      {frat.toolTop - - - - {pack -side top} {-relief flat -borderwidth 0 -array {$::t::toolList}}}
      {frat.toolTop2 - - - - {pack -side top} {-relief flat -borderwidth 0 -array {$::t::toolList2}}}
      {fral frat T 8 1 {-st nws -rw 1}}
      {.ButHome - - 1 1 {-st we} {-t "General" -com "t::chanTab nbk" -style TButtonWest}}
      {.but2 fral.butHome T 1 1 {-st we} {-t "View" -com "t::chanTab nbk2" -style TButtonWest}}
      {.butChange fral.but2 T 1 1 {-st we} {-t "Editor" -com "t::chanTab nb3" -style TButtonWest}}
      {.butFile fral.butChange T 1 1 {-st we} {-t "Files" -com "t::chanTab nb4" -style TButtonWest}}
      {.but5 fral.butFile T 1 1 {-st we} {-t "Tools" -com "t::chanTab nb5" -style TButtonWest}}
      {.butConfig fral.but5 T 1 1 {-st we} {-t "Keys" -com "t::chanTab nb6" -style TButtonWest}}
      {.butMisc fral.butConfig T 1 1 {-st we} {-t "Misc" -com "t::chanTab nb7" -style TButtonWest}}
      {.fra  fral.butMisc T 1 1 {-st we -rw 10} {-h 30.m}}
      {buth fral T 1 1 {-st we} {-t "Help" -com t::helpAbout}}
      {frau buth L 1 1 {-st nswe -cw 10} {-w 60.m}}
      {butApply frau L 1 1 {-st e} {-t "Apply"  -com t::applyProc}}
      {butCancel butApply L 1 1 {-st e} {-t "Cancel" -com t::cancelProc}}
      {butOK butCancel L 1 1 {-st e} {-t "OK"     -com t::okProc}}
      {#fra2 fral L 8 9 {-st nsew}}
      {fra fral L 8 9 {-st nsew}}
      {fra.Nbk - - - - {pack -side top} {
        f1 {-text " 1st tab of General " -underline 2 -tip "General widgets:\n- entries\n- choosers\n- text viewer/editor\n- tk_optionCascade\n- tablelist"}
        f2 {-text " Ttk demos/ttkpane.tcl " -underline 1 -tip "The code taken from\nTk's demos/ctext.tcl.\n\nDistributed with Tcl/Tk."}
        f3 {-text " Non-themed " -underline 1 -tip "Non-ttk widgets,\nthough themed in apave."}
        f4 {-text " Misc. widgets " -underline 1 -tip "Miscellaneous ttk widgets."}
        f5 {-text " Color schemes " -underline 1 -tip "Colored patterns\nof color schemes."}
        -traverse yes -select f2
      }}
      {fra.nbk2 - - - - {pack forget -side top} {
        f1 {-text "Links etc." -tip "Various widgets:\n- check/radio buttons\n- links from text/image\n- listbox from file\n- two independent calendars"}
        f2 {-text "Scrolled frame" -tip "Example of scrolled frame\nwith file viewer and comboboxes"}
        f3 {-text "< Calendar $::t::year >" -tip "All-months-of-year calendar.\n\nIt allows to select a list\nof days in years and months.\n\nAll of days allow left and right\nclicks to call callbacks with\nthe wildcards:\n- %y, %m, %d (date)\n- %X, %Y (pointer coordinates)"}
        -tr {just to test "-tr*" to call ttk::notebook::enableTraversal}
      }}
    }
  }

  proc pave_Nbk1_Tab1 {} {

    return {
      ####################################################################
      # {#
      #                1ST TAB (ENTRIES AND CHOOSERS)
      # }
      ####################################################################
      #####<~~~~-it's-a-comment-(being-a-record-as-one-continuous-string)
      # {# <~~~~ it's a comment mark (being first in a {...} record)
      #
      # Comments are marked by "#" as the 1st character of layout record.
      #
      # A menubar can be defined in any place of window layout because
      # it is assigned to a whole window.
      # }
      ####################################################################
      {Menu - - - - - {-array {
            File "&File"
            #Commented &Commented
            edit &Edit
            Help "&Help (wordy)"
      }} ::t::fillMenu}
      {labB1 - - 1 1   {-st es}  {-t "First option:"}}
      {ent1 labB1 L 1 9 {-st wes -cw 1} {-tvar t::en1}}
      {labB2 labB1 T 1 1 {-st es}  {-t "Second option:"}}
      {ent2 labB2 L 1 9 {-st wes} {-tvar t::en2}}
      {h_0 labB2 T 1 9}
      {labBA h_0 T 1 1 {-st ws}  {-t "Default find mode: "}}
      {radA labBA L 1 1 {-st ws}  {-t "Exact" -var t::v2 -value 1}}
      {radB radA L 1 1 {-st ws}  {-t "Glob" -var t::v2 -value 2}}
      {radC radB L 1 1 {-st ws}  {-t "RE" -var t::v2 -value 3}}
      {v_1 labBA T 1 9 }
      {labBfil1 v_1 T 1 1 {-st e} {-t "Pick a file:"}}
      {labBfis1 labBfil1 T 1 1 {-st e} {-t "Pick a file to save as:"}}
      {labBdir1 labBfis1 T 1 1 {-st e} {-t "Pick a directory:"}}
      {labBfon1 labBdir1 T 1 1 {-st e} {-t "Pick a font:"}}
      {labBdat1 labBfon1 T 1 1 {-st e} {-t "Pick a date:"}}
      {labBclr1 labBdat1 T 1 1 {-st e} {-t "Pick a color:"}}
      {labBftx1 labBclr1 T 1 1 {-st ne -ipady 8}
        {-t "Pick a file to view:\n\n\n\nBut the first 'view'\nmay be modified!"}}
      {fil1 labBfil1 L 1 9 {} {-tvar t::fil1 -title {Pick a file}
        -filetypes {{{Tcl scripts} .tcl} {{All files} .* }}}}
      {fis1 labBfis1 L 1 9 {} {-tvar t::fis1 -title {Save as}}}
      {diR1 labBdir1 L 1 9 {} {-tvar t::dir1 -title {Pick a directory}
      -values {saved/dir/path1 "C:\\Users\\I Me My\\my saved path"}}}
      {fon1 labBfon1 L 1 9 {} {-tvar t::fon1 -title {Pick a font}}}
      {Dat1 labBdat1 L 1 9 {} {-tvar t::dat1 -title {Pick a date} -dateformat %Y.%m.%d}}
      {clr1 labBclr1 L 1 9 {} {-tvar t::clr1 -title {Pick a color}}}
      {Ftx1 labBftx1 L 1 9 {} {-h 7 -ro 0 -tvar ::t::ftx1 -title {Pick a file to view} -filetypes {{{Tcl scripts} .tcl} {{Text files} {.txt .test}}} -wrap word -tooltip "After choosing a file\nthe text will be read-only." -tabnext "[t::pave Opc1]"}}
      {labOpc labBftx1 T 2 1 {-st ens} {-t "tk_optionCascade:"}}
      {frAopc labOpc L 1 9 {-st w -pady 9}}
      ###############____opc1____good_way
      {#.lab1 - - - - {-st e} {-t " 1st way, good:"}}
      {.Opc1 - - 1 1 {-st w} {::t::opcvar ::t::opcItems {-width -4} \
        {t::opcPre %a} -command t::opcPost }}
      ###############____opc2____bad_way
      {#.lab2 frAopc.opc1 L 1 2 {-st e} {-t "       2nd way, bad:"}}
      {#.opc2 frAopc.lab2 L 1 1 {-st w} {::t::opcvar \
        {{color red green blue -- {colored yellow magenta cyan \
        | #52CB2F #FFA500 #CB2F6A | #FFC0CB #90EE90 #8B6914}} \
        {hue dark medium light} -- {{multi word example}} ok} {-width 16} \
        { if {{%a} in {yellow magenta cyan} || ![string first # {%a}]} \
        {set _ {-background %a -activeforeground %a}} else {set _ {}} } \
        -command {puts "2nd way ::t::opcvar = [set ::t::opcvar]"} }}
      {labtbl1 labOpc T 1 1 {-st e} {-t "Tablelist widget:\n\n(click on titles\nto sort)"}}
      {frAT labtbl1 L 1 9 {-st ew}}
      {frAT.TblWid1 - - - - {pack -side left -fill x -expand 1} {-h 5 -lvar ::t::tbllist  -lbxsel buT -columns {$::t::tblcols} -ALL yes}}
      {frAT.sbv frAT.tblWid1 L - - {pack}}
      {labB4 labtbl1 T 3 9 {-st ewns -rw 1} {-t "Some others options can be below"}}
    }
  }

  proc pave_Nbk1_Tab2 {} {

    # initializing images for toolbar
    foreach {i icon} {0 retry 1 add 2 delete 3 previous 4 next 5 run 6 double 7 find} {
      image create photo IMG_$i -data [::apave::iconData $icon]
    }
    return {
      ####################################################################
      # {#               2ND TAB (DEMO OF ttk::panewindow)               }
      ####################################################################
      {tool - - - - {pack -side top} {-array {
            IMG_1 {{::t::toolBut 1} -state disabled -tooltip \
              "Start progress\n(and, for fun, enable some menu items)@@ -under 5"}
            h_ 3
            IMG_2 {{::t::toolBut 2} -tooltip \
              "Stop progress\n(and, for fun, disable some menu items)@@ -under 5"}
            sev 7
            h_ 1
            IMG_5 {{::t::e_menu} -tooltip "Run e_menu@@-under 5"}
            h_ 1
            IMG_6 {{::t::screenshooter} -tooltip "Run screenshooter@@ -under 5"}
            h_ 1
            IMG_7 {{::t::aloupe} -tooltip "Run aloupe@@ -under 5"}
            sev 7
            h_ 1
            opcTheme {::t::opct ::t::opcThemes {-width 7} {} -command ::t::opcToolPost -tooltip {Current ttk theme\n\nNOTE: awthemes are active only\nif a color scheme isn't "-2 None".@@ -under 3}}
            {# h_ 1}
            {IMG_3 {{::t::toolBut 3 \[set ::t::prevcs\]}}}
            h_ 1
            opcTool {::t::opcc ::t::opcColors {-width 16} {::t::opcToolPre %a} -command ::t::opcToolPost -tooltip "Current color scheme@@ -under 3"}
            {# h_ 1}
            {IMG_4 {{::t::toolBut 4 \[set ::t::nextcs\]}}}
            h_ 4
            ChbRestart {-var ::t::restart -t "Restart" -command {::t::toolBut 0 -2 no no} \
              -tooltip "To restart test2_pave.tcl\nwhen theme / CS changes\n\nlike File/Restart menu item@@ -under 3"}
            sev 4
            lab1 {" Hue:"}
            Spx_Hue  {-tvar ::t::hue -command {::t::hueCheck} -from -7 -to 7 -w 3 -justify center -tooltip "Color hues:\n- enabled if 'Color scheme' is chosen@@ -under 3"}
            lab2 {"  Zoom:"}
            Spx_FS  {-tvar ::t::fontsz -command {::t::fontszCheck} -from 8 -to 16 -w 3 -justify center -tooltip "Font size:\n- enabled if 'Restart' is off@@ -under 3" -myown {
              puts "\nA local/global configuration may be set with -myown attribute, e.g.\
              \n  %w configure -bg yellow -font {-weight bold}\
              \n  ::NS::GLOBAL_CONFIG %w"}}
            h_ 4
            opcIconSet {::t::opcIcon ::t::opcIconSet {} {} -command ::t::opcIconSetPost -tooltip "With this option selected\nand 'Restart' option on,\nthe test would be restarted."}
      }}}
      {# remove this comment to view another way to make a statusbar:
       stat - - - - {pack -side bottom} {-array {
            {Row:       -font {-slant italic -size 10}} 7
            {" Column:" -font {-slant italic -size 10}} 5
            {"" -font {-slant italic -size 10} -anchor e} 30
      }}}
      {lab1 - - - - {pack -pady 0} {-t \
      "It's a bit modified Tk's demos/ttkpane.tcl" -font "-weight bold -size 12"}}
      {lab2 - - - - {pack} {-t "This demonstration shows off a nested set of themed paned windows. Their sizes can be changed by grabbing the area between each contained pane and dragging the divider." -wraplength 4i -justify left}}
      {fra - - - - {pack -side bottom -fill both -expand 1 -pady 0}}
      {fra.pan - - - - {pack -side bottom -fill both -expand 1} {-orient horizontal}}
      {fra.pan.panL - - - - {add} {-orient vertical}}
      {.lfrT - - - - {add} {-t Button}}
      {.lfrT.but - - - - {pack -fill both -expand 1} {-t "Press Me" -com "t::pdlg ok info {Button Pressed} {That hurt...} -root .win -head {Ouch! Wow!\nMiau!} -weight bold -timeout {5 Lab1}" -tooltip "Shows a message with 5 sec. timeout"}}
      {.Lframe - - - - {add} {-t Clocks}}
      {fra.pan.panR - - - - {add} {-orient vertical}}
      {.lfrT - - - - {add} {-t Progress}}
      {.lfrT.Pro - - - - {pack -fill both -expand 1} {-mode indeterminate -afteridle {%w start}}}
      {.LfrB - - - - {add} {-t "Bar of tabs"}}
      {.lfrB.BtsBar  - - - - {pack -side top -fill x} {::t::fillBarTabs %w}}
      {.lfrB.fraHead  - - - - {pack -side top -fill x}}
      {.lfrB.fraHead.LabEdit  - - - - {pack -side left -expand 1 -fill x -pady 3}}
      {.lfrB.fraHead.FraFind  - - - - {pack forget -side left -fill x} {}}
      {.lfrB.fraHead.fraFind.lab  - - - - {pack -side left} {-t "Find:"}}
      {.lfrB.fraHead.fraFind.EntFind  - - - - {pack -side left -pady 3 -padx 5} {-tvar ::t::Find -w 20}}
      {.lfrB.stat - - - - {pack -side bottom} {-array {
        {# Commented       -font {-slant italic -size 10}} 7
        {Row:       -font {-slant italic -size 10}} 7
        {" Column:" -font {-slant italic -size 10}} 5
        {"" -font {-slant italic -size 10} -anchor e} 40
      }}}
      {# 2 use cases: full path & 'apavish' path }
      {.lfrB.GutText .lfrB.stat T - - {pack -side left -expand 0 -fill both} {}}
      {#.lfrB.Text .lfrB.canLines T - - {pack -side left -expand 1 -fill both} {-borderwidth 0 -w 80 -h 10 -wrap word -tabnext .win.fra.fral.butHome -gutter .win.fra.fra.nbk.f2.fra.pan.panR.lfrB.gutText -gutterwidth 5 -guttershift 4}}
      {.lfrB.Text .lfrB.canLines T - - {pack -side left -expand 1 -fill both} {-borderwidth 0 -w 80 -h 10 -wrap word -tabnext .win.fra.fral.butHome -gutter GutText -gutterwidth 5 -guttershift 4 -textpop {popupFindCommands ::t::findTclFirst ::t::findTclNext}}}
      {.lfrB.sbv .lfrB.text L - - {pack -side top}}
    }
  }

  proc pave_Nbk1_Tab3 {} {

    return {
      ####################################################################
      # {#                3RD TAB: ENABLED NON-TTK WIDGETS               }
      ####################################################################
      {fra1 - - 1 1 {-st w}}
      {.laB0  - - 1 1 {-st w} {-t "Enabled widgets"}}
      {.laB  fra1.laB0 T 1 1 {-st w -pady 1} {-t "label" -font "-weight bold -size 11"}}
      {.buTRun fra1.laB T 1 1 {-st w} {-t "button" -com ::t::Pressed}}
      {.chB fra1.buTRun T 1 1 {-st w -pady 5} {-t "  checkbutton"}}
      {.frAE fra1.chB T 1 1 {-st w}}
      {.frAE.laB - - 1 1 {-st w} {-t "entry "}}
      {.frAE.enT fra1.frAE.laB L 1 1 {-st w -pady 5} {-tvar t::tv2}}
      {.frA fra1.frAE T 1 1 {-st w}}
      {.frA.laB - - 1 1 {-st w -ipady 5} {-t "label in frame" -font "-weight bold -size 11"}}
      {.frAS fra1.frA T 1 1 {-st w -pady 5}}
      {.frAS.laB - - - - {pack -side left -anchor w} {-t "spinbox 1 through 9 "}}
      {.frAS.spX - - - - {pack} {-tvar t::tv -from 1 -to 9 -w 5 -justify center}}
      {.frAsc fra1.frAS T 1 1 {-st ew -pady 5}}
      {.frAsc.laBsc - - - - {pack -side left} {-t "scale 0 through 100 "}}
      {.frAsc.scA - - - - {pack -side right} {-orient horizontal -w 12 -sliderlength 20 -length 238 -var t::sc}}
      {.frALB fra1.frAsc T 1 1}
      {.frALB.laB - - - - {pack -side left -anchor nw} {-t "listbox of colors  "}}
      {.frALB.lbx - - - - {pack -side left -fill x -expand 1} {-lvar t::lvar -h 4 -w 30 -lbxsel dark -ALL yes}}
      {.frALB.sbV fra1.frALB.lbx L - - {pack}}
      {.lfR fra1.frALB T 1 1 {-st w} {-t "labeled frame" -font "-weight bold -size 11"}}
      {.lfR.raD1 - - 1 1 {-st w -pady 5} {-t "read-only text" -var t::v2 -value 1
        -com ::t::highlighting_others}}
      {.lfR.raD2 fra1.lfR.raD1 L 1 1 {-st w -padx 7} {-t "editable text" -var t::v2 -value 2 -com {::t::highlighting_others 0}}}

      ####################################################################
      # {#                   DISABLED NON_TTK WIDGETS                    }
      ####################################################################
      {labFR # # # # # {-t "labeled frame" -font "-weight bold -size 11" -state disabled -foreground gray}}
      {lfR1 fra1 L 1 1 {-st we -cw 1} {-t "Disabled counterparts"}}
      {.laB - - 1 1 {-st w -pady 5} {-t "label" -font "-weight bold -size 11" -state disabled}}
      {.BuTRun lfR1.laB T 1 1 {-st w} {-t "button" -state disabled}}
      {.chB lfR1.BuTRun T 1 1 {-st w -pady 5} {-t " checkbutton" -state disabled}}
      {.frAE lfR1.chB T 1 1 {-st w} {-state disabled}}
      {.frAE.laB - - 1 1 {-st w} {-t "entry " -state disabled}}
      {.frAE.enT lfR1.frAE.laB L 1 1 {-st w -pady 5} {-tvar t::tv2 -state disabled}}
      {.frA lfR1.frAE T 1 1 {-st w} {-state disabled}}
      {.frA.laB - - 1 1 {-st w -ipady 5} {-t "label in frame" -font "-weight bold -size 11" -state disabled}}
      {.frAS lfR1.frA T 1 1 {-st w -pady 5} {-state disabled}}
      {.frAS.laB - - - - {pack -side left -anchor w} {-t "spinbox 1 through 9 "  -state disabled}}
      {.frAS.spX - - - - {pack} {-tvar t::tv -from 1 -to 9 -w 5 -justify center -state disabled}}
      {.frAsc lfR1.frAS T 1 1 {-st ew -pady 5} {-state disabled}}
      {.frAsc.laBsc - - - - {pack -side left} {-t "scale 0 through 100 " -state disabled}}
      {.frAsc.scA - - - - {pack} {-orient horizontal -w 12 -sliderlength 20 -length 238 -state disabled -var t::sc}}
      {.frALB lfR1.frAsc T 1 1 {-st ew -pady 5} {-state disabled}}
      {.frALB.laB - - - - {pack -side left -anchor nw} {-t "listbox of colors  " -state disabled}}
      {.frALB.lbx - - - - {pack -side left -fill x -expand 1} {-lvar t::lvar -h 4 -w 30 -state disabled}}
      {.frALB.sbV lfR1.frALB.lbx L - - {pack -side left}}
      {.lfR lfR1.frALB T 1 1 {-st w} {-labelwidget .win.fra.fra.nbk.f3.labFR -font "-weight bold -size 11" -state disabled}}
      {.lfR.raD1 - - 1 1 {-st w -pady 5} {-t "read-only text" -var t::v2 -value 1 -state disabled}}
      {.lfR.raD2 lfR1.lfR.raD1 L 1 1 {-st w -padx 7} {-t "editable text" -var t::v2 -value 2 -state disabled}}

      ####################################################################
      # {#           FRAME FOR TEXT WIDGET OF NON-TTK WIDGET TAB         }
      ####################################################################
      {frAT fra1 T 1 2 {-st nsew -rw 1 -pady 7}}
      {frAT.LaBNT - - - - {pack -side left -anchor nw} {-t "text & scrollbars \
\n\nas above, i.e.\nnot  ttk::scrollbar\n\ntext is read-only"}}
      {frAT.TextNT - - - - {pack -side left -expand 1 -fill both} {-h 5 -wrap none -rotext ::t::filetxt -tabnext .win.fra.fral.butHome}}
      {frAT.sbV frAT.textNT L - - {pack}}
      {frAT.sbH frAT.textNT T - - {pack -before %w}}
    }
  }

  proc pave_Nbk1_Tab4 {} {

    return {
      {can - - - - {pack} {-h 130 -w 360 -afteridle ::t::TextConfigPie}}
      {seh - - - - {pack -pady 7 -fill x}}
      {lab - - - - {pack} {-tvar t::sc2}}
      {sca - - - - {pack} {-length 500 -o horiz -var t::sc -from 0 -to 100}}
      {seh2 - - - - {pack -pady 7 -fill x}}
      {SpxMisc - - - - {pack} {-tvar t::tv -from 1 -to 9 -w 5 -justify center}}
      {seh3 - - - - {pack -pady 7 -fill x}}
      {lab1 - - - - {pack} {-t "Combobox is sort of separate widget."}}
      {v_1 - - - - {pack} {-h 3}}
      {cbx1 - - - - {pack} {-tvar ::cb1 -inpval EVENT -values {MENU EVENT COMMAND}}}
      {v_2 - - - - {pack} {-h 3}}
      {cbx4 - - - - {pack} {-tvar ::cb2 -inpval MENU-readonly -values {MENU-readonly EVENT-readonly COMMAND-readonly} -state readonly}}
      {seh5 - - - - {pack -pady 9 -fill x}}
      {lab2 - - - - {pack} {-t "File content combobox (fco) contains text file(s) content. Its 'values' attribute is set like this:
  -values {TEXT1 @@-div1 \" <\" -div2 > -ret yes test1.txt@@ TEXT2 @@-pos 0 -len 7 -list {a b c} test2.txt@@ ...}
where:
  TEXT1, TEXT2, ... TEXTN - optional text snippets outside of @@ ... @@ data sets
  @@ ... @@ - data set for a file, containing the file name and (optionally) its preceding options:
      -div1, -div2 - dividers to filter file lines and to cut substrings from them:
          if -div1 omitted, from the beginning; if -div2 omitted, to the end of line
      -pos, -len - position and length of substring to cut:
          if -pos omitted, -len characters from the beginning; if -len omitted, to the end of line
      -list - a list of items to put directly into the combobox
      -ret - if set to yes, means that the field is returned instead of full string
  If there is only a single data set and no TEXT, the @@ marks may be omitted. The @@ marks are configured."}}
      {v_3 - - - - {pack} {-h 3}}
      {fco - - - - {pack} {-tvar t::cb3 -w 88 -tooltip "This 'fco' combobox contains: \
      \n  1) four literal lines\n  2) data from 'test2_fco.dat' file" -values {COMMIT: @@-div1 " \[" -div2 "\] " -ret yes test2_fco.dat@@   INFO: @@-pos 22 -list {{Content of test2_fco.dat} {another item} trunk DOC} test2_fco.dat@@}}}
      {siz - - - - {pack -side bottom -anchor se}}
    }
  }

  proc pave_Nbk1_Tab5 {} {

    return {
      ####################################################################
      # {#                TAB-5: COLOR SCHEMES                           }
      ####################################################################
      {BuTClrN  - - 1 2 {-st nsew -rw 1 -cw 1} {-com {::t::toolBut 4 -2} -text "CS -2: Default"}}
      {BuTClrB  BuTClrN L 1 2 {-st nsew -rw 1 -cw 1} {-com {::t::toolBut 4 -1} -text "CS -1: Basic"}}
      {tcl {
        set prt BuTClrN
        for {set i 0} {$i<48} {incr i} {
          set cur "BuTClr$i"
          if {$i%4} {set n $pr; set p L} {set n $prt; set p T; set prt $cur}
          set pr $cur
          set lwid "$cur $n $p 1 1 {-st nsew -rw 1 -cw 1} {-com \
           {::t::toolBut 4 $i} -t \"CS [t::pave csGetName $i]\"}"
          %C $lwid
        }
      }}
    }
  }

  proc pave_Nbk2_Tab1 {} {

    set sec [clock seconds]
    set ::t::formatKlnd1 %d.%m.%Y
    set ::t::formatKlnd2 %m/%d/%Y
    set ::t::dateKlnd1 [clock format $sec -format $::t::formatKlnd1]
    set ::t::dateKlnd2 10/30/2021
    return {
      ####################################################################
      # {#               TABS OF VIEW (JUST TO BE PRESENT)               }
      ####################################################################
      {labB  -   - 1 1 {-st w} {-t "Defaults"}}
      {chb1 labB T 1 2 {-st w} {-t "Match whole word only" -var t::c1}}
      {chb2 chb1 T 1 2 {-st w} {-t "Match case"  -var t::c2}}
      {chb3 chb2 T 1 2 {-st w} {-t "Wrap around" -var t::c3}}
      {sev1 chb1 L 3 1 }
      {labB3 sev1 L 1 1 {-st w} {-t "Direction:"}}
      {rad1 labB3 T 1 1 {-st w} {-t "Down" -var t::v -value 1}}
      {rad2 rad1 L 1 1 {-st w} {-t "Up"   -var t::v -value 2}}
      {v_ chb3 T 1 5}
      {fraflb v_ T 1 5 {-st ew -pady 10} {}}
      {fraflb.butEdit - - - - {pack -side right -anchor nw -padx 9} {-t "Edit the file" -com t::viewfile -tooltip "Opens a stand-alone editor of the file\nthe listbox' data are taken from." -image ICN31-small -compound left}}
      {fraflb.lab - - - - {pack -side left -anchor nw} {-t "Listbox of file content:\n\nSee also:\nGeneral/Misc. tab" -link "
      ::t::chanTab nbk .win.fra.fra.nbk.f4 no yes; focus [::t::pave SpxMisc]@@Click to select 'Misc.'\n... and mark the link as visited.@@"}}
      {fraflb.flb - - - - {pack -side left -fill x -expand 1} {-lvar ::t::lv1 -lbxsel Cont -ALL 1 -w 50 -h 5 -tooltip "The 'flb' listbox contains:\n 1)  four literal lines\n  2) data from 'test2_fco.dat' file" -values {@@-div1 " \[" -div2 "\] " test2_fco.dat@@   INFO: @@-pos 22 -ret 1 -list {{Content of test2_fco.dat} {another item} trunk DOC} test2_fco.dat@@ Code of test2_pave.tcl: @@-RE {^(\s*)([^#]+)$} ./test2_pave.tcl@@}}}
      {fraflb.sbv fraflb.flb L - - {pack -side left -after %w}}
      {fraflb.sbh fraflb.flb T - - {pack -side left -before %w}}
      {LabImg fraflb T 1 1 {} {-link "::t::goWiki@@Click to enter the bird's wiki@@"}}
      {LabImgInfo LabImg T 1 1 {} {-link "
      ::t::chanTab nbk .win.fra.fra.nbk.f4 no yes; focus [::t::pave SpxMisc]@@Click to select 'Misc.'\n... and mark the link as visited\n(to test the multiple visited links).@@" -afteridle ::t::labelImaged}}
      {labklnd LabImgInfo T 1 4 {-st nswe} {-t {\nExample of calendar #1}}}
      {daTklnd labklnd T 1 1 {-st nw} {-borderwidth 1 -relief raised -dateformat $::t::formatKlnd1 -tvar ::t::dateKlnd1 -com {puts "date1=$::t::dateKlnd1 (DMY=%d.%m.%y)"}}}
      {labklnd2 labklnd L 1 4 {-st nswe} {-t {\nExample of calendar #2}}}
      {daTklnd2 labklnd2 T 1 1 {-st nw} {-borderwidth 1 -relief raised -dateformat $::t::formatKlnd2 -tvar ::t::dateKlnd2 -com {puts "date2=$::t::dateKlnd2 (DMY=%d.%m.%y)"} -locale en_us}}
    }
  }

  proc pave_Nbk2_Tab2 {} {
    return {
      {v_ - - 1 1}
      {ftx v_ T 1 9 {} {-h 7 -w 77 -ro 1 -tvar ::t::ftx2 -title {Pick a file to view} -filetypes {{{Tcl scripts} .tcl} {{Text files} {.txt .test}}} -wrap word -tooltip {Just for demo} -tabnext .win.fra.fral.butHome}}
      {fra ftx T 1 1 {-st nsew -cw 1 -rw 1}}
      {fra.scf - - 1 1  {pack -fill both -expand 1}}
      {tcl {
        set ftx Ftx2
        set pr fra.scf.ftx2
        set lwid ".$ftx - - 1 9 {} {-h 7 -w 77 -ro 1 -tvar ::t::ftx3 -title {Pick a file to view} -filetypes {{{Tcl scripts} .tcl} {{Text files} {.txt .test}}} -wrap word -tooltip {Just for demo} -tabnext .win.fra.fral.butHome}"
        %C $lwid
        set values {a b c d}
        for {set i 0} {$i<40} {incr i} {
          lappend values $i
          set lab "lab$i"
          set cbx "CbxKey$i"
          set lwid ".$lab $pr T 1 1 {-st w -pady 1 -padx 3} {-t \"Label $i\"}"
          %C $lwid
          set lwid ".$cbx fra.scf.$lab L 1 1 {-st we} {-tvar ::t::scfvar$i -values {$values} -state readonly}"
          %C $lwid
          set pr fra.scf.$lab
        }
      }}
    }
  }

  proc yearCurr {} {
    set wy [pave ButKlndYear]
    set year [$wy cget -text]
    set to [expr {[lindex [::klnd::currentYearMonthDay] 0] - $year}]
    yearNext $to
  }

  proc yearNext {to} {
    set wy [pave ButKlndYear]
    set year [$wy cget -text]
    incr year $to
    set yearmin [::klnd::minYear]
    set yearmax [::klnd::maxYear]
    if {$year<$yearmin} {set year $yearmin}
    if {$year>$yearmax} {set year $yearmax}
    $wy configure -text $year
    foreach month {1 2 3 4 5 6 7 8 9 10 11 12} {
      ::klnd::update [expr {$month+2}] $year $month
    }
    .win.fra.fra.nbk2 tab .win.fra.fra.nbk2.f3 -text "< Calendar $year >"
    update
  }

  proc pave_Nbk2_Tab3 {} {
    return {
      {fra - - - - {-st nsew -cw 1 -rw 1}}
      {fra.scf - - 1 1  {pack -fill both -expand 1}}
      {fra.scf.fra - - 1 2 {-st ew}}
      {.buT1 - - - - {pack -side left} {-image ICN43 -compound left -com {::t::yearNext -50} -t {Prior 50}}}
      {.buT12 - - - - {pack -side left} {-image ICN41 -compound left -com {::t::yearNext -1} -t {Prior 1}}}
      {.ButKlndYear - - - - {pack -side left -anchor center -expand 1} {-com ::t::yearCurr -t $::t::year -style TButtonBold -tip "Click to set\nthe current."}}
      {.buT22 - - - - {pack -side left} {-image ICN42 -compound right -com {::t::yearNext 1} -t {Next 1}}}
      {.buT2 - - - - {pack -side left} {-image ICN44 -compound right -com {::t::yearNext 50} -t {Next 50}}}
      {tcl {
        set day1 [clock scan "$::t::year/5/1" -format %Y/%N/%e]
        set day1 [clock format $day1 -format $::t::formatKlnd1]
        set day2 [clock scan "$::t::year/9/20" -format %Y/%N/%e]
        set day2 [clock format $day2 -format $::t::formatKlnd1]
        set day3 [clock scan "$::t::year/12/15" -format %Y/%N/%e]
        set day3 [clock format $day3 -format $::t::formatKlnd1]
        set daylist [list $day1 $day2 $day3]
        set prevW fra.scf.fra
        set prevP T
        for {set m 1} {$m<=12} {incr m} {
          if {$m==$::t::month} {
            set sel "-currentmonth $::t::year/$::t::month"
          } else {
            set sel "-currentmonth {}"
          }
          set day2 [clock scan "$::t::year/$m/1" -format %Y/%N/%e]
          set day2 [clock format $day2 -format $::t::formatKlnd1]
          set ::t::idateKlnd$m $day2
          set lwid [list fra.scf.daT$m $prevW $prevP 1 1 {-st nw} "-relief raised -dateformat $::t::formatKlnd1 -tvar ::t::idateKlnd$m -daylist {$daylist} -com \"puts date=\$::t::idateKlnd$m\" -popup {puts {%y/%m/%d, at (%X,%Y)}} -united yes $sel -locale en"]
          %C $lwid
          set prevW fra.scf.daT[expr {$m - ($m%2?0:1)}]
          if {$m % 2} {set prevP L} {set prevP T}
        }
      }}
    }
  }

# ______________________ The test's main procedure ______________________ #

  proc test2_pave {} {

    variable pdlg
    variable pave
    ::apave::obj progress_Begin {} .win Starting {Wait a little...} {} 1280 -length 250
    set firstin [expr {$::t::newCS==[apave::cs_Non]}]
    apave::APaveInput create pdlg .win
    set ::t::paveobj [apave::APaveInput create pave .win $::t::newCS]
    pave initLinkFont -slant italic -underline 1
    pave untouchWidgets *buTClr*
    if {!$firstin} {pave basicFontSize $::t::fontsz}
    set ::t::filetxt [::apave::readTextFile $::t::ftx1]
    set ::t::Find ""
    set ::multiline 1
    set ::t::tblcols {
      0 {Name of widget} left \
      0 Type left \
      0 Id right \
      0 Msc right
    }
    foreach {k v} [pave defaultAttrs] {
      incr itbll
      lappend ::t::tbllist [list $k [lindex [pave widgetType $k {} {}] 0] \
        $itbll [string range $k [expr {$itbll%3}] end]]
    }
    set ::t::opcItems [list {{Color list} red green blue -- {colored yellow magenta cyan
      | #52CB2F #FFA500 #CB2F6A | #FFC0CB #90EE90 #8B6914}} \
      {hue dark medium light} -- {{multi word example}} ok]
    set ::t::opcColors [list {{-2: None}}]
    for {set i -1; set n [apave::cs_MaxBasic]} {$i<=$n} {incr i} {
      if {(($i+2) % ($n/2+2)) == 0} {lappend ::t::opcColors "|"}
      lappend ::t::opcColors [list [pave csGetName $i]]
    }
    set ::t::opcIconSet [list "{small icons  }" "{middle icons  }" "{large icons  }"]
    variable arrayTab
    array set arrayTab {}
    set ::t::toolList ""
    set ::t::toolList2 ""
    set imgl [::apave::iconImage]
    set llen [llength $imgl]
    for {set i 0} {$i<$llen} {incr i} {
      set icon [lindex $imgl $i]
      set img "ICN$i"
      if {[catch {image create photo $img -data [::apave::iconData $icon]}]} {
        image create photo $img -data [::apave::iconData none]
      }
      catch {image create photo $img-small -data [::apave::iconData $icon small]}
      set tta " $img {{} -tooltip { Icon $i \n $icon @@ -under 4 -image $img -per10 5000}}"
      if {$i<$llen/2} {append ::t::toolList $tta} {append ::t::toolList2 $tta}
    }
    set ::bgst [ttk::style lookup TScrollbar -troughcolor]
    ttk::style conf TLabelframe -labelmargins {5 10 1 1} -padding 3
    trace add variable t::sc write "::t::tracer ::t::sc"
    pave defaultAttrs chB {} {-padx 11 -pady 3}  ;# to test defaultAttrs
    source [file join $::pavedirname pickers klnd klnd.tcl]
    lassign [::klnd::currentYearMonthDay] ::t::year ::t::month
    set ::t::restart 1

    # making main window object and dialog object
    pave makeWindow .win.fra "$::pkg_versions"
    pave paveWindow \
      .win.fra [pave_Main_Frame] \
      .win.fra.fra.nbk.f1 [pave_Nbk1_Tab1] \
      .win.fra.fra.nbk.f2 [pave_Nbk1_Tab2] \
      .win.fra.fra.nbk.f3 [pave_Nbk1_Tab3] \
      .win.fra.fra.nbk.f4 [pave_Nbk1_Tab4] \
      .win.fra.fra.nbk.f5 [pave_Nbk1_Tab5] \
      .win.fra.fra.nbk2.f1 [pave_Nbk2_Tab1] \
      .win.fra.fra.nbk2.f2 [pave_Nbk2_Tab2] \
      .win.fra.fra.nbk2.f3 [pave_Nbk2_Tab3]

    # text widget's name is uppercased, so we can use the Text method
    set wtex [pave Text]
    # bindings and contents for text widget
    bind $wtex <<Modified>> ::t::tabModified
    bind $wtex <Control-f> ::t::findTclFirst
    bind $wtex <F3> ::t::findTclNext
    pave displayText $wtex $::t::filetxt
    # at first, Ftx1 widget is editable
    pave makePopup [pave Ftx1] no yes
    # we can use the Lframe method to get its name, similar to Text
    fillclock [pave Lframe]

    # 3d frame - "Options" (not too much efforts applied ;^)
    set lst3 {
      {but1 -    - 1 1 {-st we} {-t "Options1" -com "t::pdlg ok info O1 Opts1... -g pointer"}}
      {but2 but1 T 1 1 {-st we} {-t "Options2" -com "t::pdlg ok ques O2 Opts2... -g pointer"}}
      {but3 but2 T 1 1 {-st we} {-t "Options3" -com "t::pdlg ok warn O3 Opts3... -g pointer"}}
      {but4 but3 T 1 1 {-st we} {-t "Options4" -com "t::pdlg ok err  O4 Opts4... -g pointer"}}
      {but5 but1 L 1 1 {-st we} {-t "more..."  -com "t::pdlg ok info M  More... -g pointer"}}
    }
    foreach b {6 7 8 9 a b c d e f g h i} p {5 6 7 8 9 a b c d e f g h} {
      lappend lst3 [list but$b but$p T 1 1 {-st we} \
        {-t "more..." -com "t::pdlg ok warn M More...[incr ::iMORE] -text 1 -w 10 -g pointer"}]
    }
    ttk::notebook .win.fra.fra.nb3
    .win.fra.fra.nb3 add [ttk::frame .win.fra.fra.nb3.f1] -text "Editor options"

    pave paveWindow .win.fra.fra.nb3.f1 $lst3

    # 4th and other frames mean even less efforts applied
    foreach {nn inf} {4 Files 5 Tools 6 "Key mappings" 7 Misc} {
      ttk::notebook .win.fra.fra.nb$nn
      pack [ttk::label .win.fra.fra.nb$nn.labB -text "$inf here..." \
        -foreground blue -font "-weight bold -size 12"] -expand 1
    }

    # colors for Colors tab
    for {set i 0} {$i<48} {incr i} {
      lassign [pave csGet $i] - fg - bg
      [pave BuTClr$i] configure -foreground $fg -background $bg
    }

    # icons of top toolbar etc.
    for {set i 0} {$i<[llength $imgl]} {incr i} {
      set ico [lindex $imgl $i]
      [pave BuT_ICN$i] configure -command \
        [list ::t::msg info " This is just a demo.\n\n Icon$i was clicked:\n <link3></link3> $ico" -tags ::t::textTags -my "after idle {::t::textIco %w $ico}" -text 1 -scroll 0 -g pointer+-10+10]
    }
    [pave Labstat3] configure -text "System encoding: [encoding system]"

    if {$firstin} {
      set ::t::nextcs [apave::cs_Min]
      set ::t::prevcs [apave::cs_MaxBasic]
    } else {
      set ::t::nextcs [expr {$::t::newCS==[apave::cs_MaxBasic] ? \
        [apave::cs_Min] : $::t::newCS+1}]
      set ::t::prevcs [expr {$::t::newCS==[apave::cs_Min] ? \
        [apave::cs_MaxBasic] : $::t::newCS-1}]
      toolBut 4 $::t::newCS yes
      if {$t::ans4==11} {[pave ChbRestart] configure -state disabled}
    }
    set ::t::newCS [apave::cs_Non]
    toolBut 0
    after 1000 ::t::highlighting_others  ;# it's unseen at changing the theme
    catch {::transpops::run [file join ~/PG/github/DEMO/pave $::t::transpopsFile] {<Alt-t> <Alt-y>} {.win .win._a_loupe_loup .win._a_loupe_disp .__tk__color .win._apave_CALENDAR_}}

    # Open the window at last
    ::apave::obj progress_End
    set ::t::curTab ""
    chanTab nbk
    set res [pave showModal .win -decor 1 -onclose t::exitProc]
    if {$::t::newCS==[apave::cs_Non]} { ;# at restart, newCS is set
      # getting result and clearance
      set res [pave res .win]
      ::t::putsResult1
      ::t::putsResult2
      ::t::putsResult3
    }
    destroy .win
    pave destroy
    pdlg destroy
    return $res
  }

} ;# end of ::t namespace

# __________________________ Running the test ___________________________ #

puts "\nThis is just a demo. Take it easy."
set test2script $::t::ftx1
set ::t::opct clam
if {$::argc>=5} {
  lassign $::argv ::t::opct ::t::newCS ::t::fontsz ::t::ans4 ::t::opcIcon ::t::hue
  set ::t::transpopsFile "transpops.txt"
} else {
  set ::t::newCS 27 ;# ForestDark CS
  set ::t::opcIcon "small"
}
set ::t::opcThemes [list default clam classic alt]
if {$::t::newCS!=-2 && ![catch {
package require awthemes
package require ttk::theme::awlight
package require ttk::theme::awdark
}]} then {
  set ::t::opcThemes [list default clam classic alt -- {{light / dark} awlight awdark}]
}
if {[catch {apave::initWM -theme $::t::opct}]} apave::initWM
if {![info exists ::t::hue] || ![string is integer -strict $::t::hue]} {set ::t::hue 0}
# check for CloudTk by Jeff Smith (on wiki.tcl-lang.org)
set ::noRestart [expr {[string match "/home/tclhttp*" $::t::ftx1]}]
if {$::noRestart} {set ::t::ans4 12}
set ::t::opcIcon [lindex $::t::opcIcon 0]
::apave::iconImage -init $::t::opcIcon
append ::t::opcIcon " icons  "
set test2res [t::test2_pave]
puts "\nResult of test2 = $test2res\n[string repeat - 77]"
if {$::t::newCS!=[apave::cs_Non] || $test2res==100} {  ;# at restart, newCS is set
  exec tclsh $test2script $::t::opct [::t::csCurrent] $::t::fontsz $::t::ans4 "$::t::opcIcon" $::t::hue &
}
::apave::endWM
exit
#-ARGS1: 23 9 12 "small icons"
