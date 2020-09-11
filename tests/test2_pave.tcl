#! /usr/bin/env tclsh
# _______________________________________________________________________ #
#
# Test 2 demonstrates most features of apave package.
# Note how the pave is applied to the frames of notebook.
# _______________________________________________________________________ #

set tcltk_version "Tcl/Tk [package require Tk]"
catch {package require tooltip} ;# may be absent

set ::testdirname [file normalize [file dirname [info script]]]
cd $::testdirname
set ::test2dirs [list "$::testdirname/.." "$::testdirname" "$::testdirname/../bartabs"]
lappend auto_path {*}$::test2dirs
set pkg_versions "apave [package require apave]"
append pkg_versions ", bartabs [package require bartabs]"

set ::e_menu_dir [file normalize [file join $::testdirname ../../e_menu]]
catch {source [file join $::e_menu_dir e_menu.tcl]}

namespace eval t {

  variable ftx0 [file join $::testdirname [file tail [info script]]]
  variable ftx1 $ftx0
  # variables used in layouts
  variable v 1 v2 1 c1 0 c2 0 c3 0 en1 "" en2 "" tv 1 tv2 "enter value" sc 0 sc2 0 cb3 "Content of test2_fco.dat" lv1 {}
  variable fil1 "" fis1 "" dir1 "" clr1 "" fon1 "" dat1 ""
  variable ans0 0 ans1 0 ans2 0 ans3 0 ans4 0 fontsz 10
  variable lvar {white blue "dark red" black #112334 #fefefe
  "sea green" "hot pink" cyan aqua "olive drab" snow wheat  }
  variable arrayTab
  variable pdlg
  variable pave

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

# ______________________ The test's main procedure ______________________ #

  proc test2_pave {} {

    variable pdlg
    variable pave
    set firstin [expr {$::t::newCS==[apave::cs_Non]}]
    apave::APaveInput create pdlg .win
    apave::APaveInput create pave .win $::t::newCS
    pave configTooltip black #FBFB95 -font {-size 11}
    pave untouchWidgets *buTClr*
    if {!$firstin} {pave basicFontSize $::t::fontsz}
    set ::t::filetxt [::apave::readTextFile $::t::ftx1]
    set ::t::tblcols {
      0 {Name of widget} left \
      0 Type left \
      0 Id right \
      0 Msc right
    }
    foreach {k v} $::apave::_Defaults {
      incr itbll
      lappend ::t::tbllist [list $k [lindex [pave getWidgetType $k {} {}] 0] \
        $itbll [string range $k [expr {$itbll%3}] end]]
    }
    set ::t::opcItems [list {{Color list} red green blue -- {colored yellow magenta cyan
      | #52CB2F #FFA500 #CB2F6A | #FFC0CB #90EE90 #8B6914}} \
      {hue dark medium light} -- {{multi word example}} ok]
    set ::t::opcColors [list {{Color schemes}}]
    for {set i -1; set n [apave::cs_Max]} {$i<=$n} {incr i} {
      if {(($i+2) % ($n/2+2)) == 0} {lappend ::t::opcColors "|"}
      lappend ::t::opcColors [list "$i: [pave csGetName $i]"]
    }
    variable arrayTab
    array set arrayTab {}
    # initializing images for toolbar
    set imgl [::apave::iconImage]
    set imgused 0
    foreach {i icon} {0 retry 1 add 2 delete 3 undo 4 redo 5 run} {
      image create photo Img$i -data [::apave::iconData $icon]
      incr imgused
    }
    set ::t::toolList ""
    for {set i 0} {$i<[llength $imgl]} {incr i} {
      set icon [lindex $imgl $i]
      set img "Img[expr {$i+$imgused}]"
      if {[catch {image create photo $img -data [::apave::iconData $icon]}]} {
        image create photo $img -data [::apave::iconData none]
      }
      append ::t::toolList " $img {{} -tooltip {Icon: $icon}}"
    }
    set ::bgst [ttk::style lookup TScrollbar -troughcolor]
    ttk::style conf TLabelframe -labelmargins {5 10 1 1} -padding 3
    trace add variable t::sc write "::t::tracer ::t::sc"
    pave setDefaultAttrs chB {} {-padx 11 -pady 3}  ;# to test setDefaultAttrs
    set ::t::restart 1

    # making main window object and dialog object
    pave configure edge "@@"
    pave makeWindow .win.fra "Packages: $::pkg_versions"
    pave paveWindow .win.fra {
      {frat - - 1 20 {-st we} }
      {frat.toolTop - - - - {pack -side top} {-array {$::t::toolList}}}
      {fral frat T 8 1 {-st nws -rw 1}}
      {.butHome - - 1 1 {-st we} {-t "General" -com "t::chanTab nbk"}}
      {.but2 fral.butHome T 1 1 {-st we} {-t "View" -com "t::chanTab nbk2"}}
      {.butEdit fral.but2 T 1 1 {-st we} {-t "Editor" -com "t::chanTab nb3"}}
      {.butFile fral.butEdit T 1 1 {-st we} {-t "Files" -com "t::chanTab nb4"}}
      {.but5 fral.butFile T 1 1 {-st we} {-t "Tools" -com "t::chanTab nb5"}}
      {.butConfig fral.but5 T 1 1 {-st we} {-t "Key maps" -com "t::chanTab nb6"}}
      {.butMisc fral.butConfig T 1 1 {-st we} {-t "Misc" -com "t::chanTab nb7"}}
      {.fra  fral.butMisc T 1 1 {-st we -rw 10} {-h 30.m}}
      {buth fral T 1 1 {-st we} {-t "Help" -com t::helpProc}}
      {frau buth L 1 1 {-st nswe -cw 10} {-w 60.m}}
      {butApply frau L 1 1 {-st e} {-t "Apply"  -com t::applyProc}}
      {butCancel butApply L 1 1 {-st e} {-t "Cancel" -com t::cancelProc}}
      {butOK butCancel L 1 1 {-st e} {-t "OK"     -com t::okProc}}
      {#fra2 fral L 8 9 {-st nsew}}
      {fra fral L 8 9 {-st nsew}}
      {fra.nbk - - - - {pack -side top} {
        f1 {-text " 1st tab of General " -underline 2}
        f2 {-text " Ttk demos/ttkpane.tcl " -underline 1}
        f3 {-text " Non-themed " -underline 1}
        f4 {-text " Misc. widgets " -underline 1}
        f5 {-text " Color schemes " -underline 1}
        -traverse yes -select f2
      }}
      {fra.nbk2 - - - - {pack forget -side top} {
        f1 {-text "First of View" -underline 1}
        f2 {-text "Second of View" -underline 10}
        -tr {just to test "-tr*" to call ttk::notebook::enableTraversal}
      }}
    } .win.fra.fra.nbk.f1 {

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
            edit &Edit
            help "&{Help (wordy)}"
      }}}
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
      {labBclr1 labBfon1 T 1 1 {-st e} {-t "Pick a color:"}}
      {labBdat1 labBclr1 T 1 1 {-st e} {-t "Pick a date:"}}
      {labBftx1 labBdat1 T 1 1 {-st ne -ipady 8}
        {-t "Pick a file to view:\n\n\n\nBut the first 'view'\nmay be modified!"}}
      {fil1 labBfil1 L 1 9 {} {-tvar t::fil1 -title {Pick a file}
        -filetypes {{{Tcl scripts} .tcl} {{All files} .* }}}}
      {fis1 labBfis1 L 1 9 {} {-tvar t::fis1 -title {Save as}}}
      {dir1 labBdir1 L 1 9 {} {-tvar t::dir1 -title {Pick a directory}}}
      {fon1 labBfon1 L 1 9 {} {-tvar t::fon1 -title {Pick a font}}}
      {clr1 labBclr1 L 1 9 {} {-tvar t::clr1 -title {Pick a color}}}
      {dat1 labBdat1 L 1 9 {} {-tvar t::dat1 -title {Pick a date} -dateformat %Y.%m.%d}}
      {Ftx1 labBftx1 L 1 9 {} {-h 7 -ro 0 -tvar ::t::ftx1 -title {Pick a file to view} -filetypes {{{Tcl scripts} .tcl} {{Text files} {.txt .test}}} -wrap word -tooltip "After choosing a file\nthe text will be read-only." -tabnext "[t::pave Opc1]"}}
      {labOpc labBftx1 T 2 1 {-st ens} {-t "tk_optionCascade:"}}
      {frAopc labOpc L 1 9 {-st w -pady 9}}
      ###############____opc1____good_way
      {.lab1 - - - - {-st e} {-t " 1st way, good:"}}
      {.Opc1 frAopc.lab1 L 1 1 {-st w} {::t::opcvar ::t::opcItems {-width -4} \
        {t::opcPre %a} -command t::opcPost }}
      ###############____opc2____bad_way
      {.lab2 frAopc.opc1 L 1 2 {-st e} {-t "       2nd way, bad:"}}
      {.opc2 frAopc.lab2 L 1 1 {-st w} {::t::opcvar \
        {{color red green blue -- {colored yellow magenta cyan \
        | #52CB2F #FFA500 #CB2F6A | #FFC0CB #90EE90 #8B6914}} \
        {hue dark medium light} -- {{multi word example}} ok} {-width 16} \
        { if {{%a} in {yellow magenta cyan} || ![string first # {%a}]} \
        {set _ {-background %a -activeforeground %a}} else {set _ {}} } \
        -command {eval puts "2nd way ::t::opcvar = [set ::t::opcvar]"} }}
      {labtbl1 labOpc T 1 1 {-st e} {-t "Tablelist widget:\n\n(click on titles\nto sort)"}}
      {frAT labtbl1 L 1 9 {-st ew}}
      {frAT.TblWid1 - - - - {pack -side left -fill x -expand 1} {-h 5 -lvar ::t::tbllist  -lbxsel buT -columns {$::t::tblcols} -ALL yes}}
      {frAT.sbv frAT.tblWid1 L - - {pack}}
      {labB4 labtbl1 T 3 9 {-st ewns -rw 1} {-t "Some others options can be below"}}
    } .win.fra.fra.nbk.f2 {

      ####################################################################
      # {#               2ND TAB (DEMO OF ttk::panewindow)               }
      ####################################################################
      {tool - - - - {pack -side top} {-array {
            Img1 {{::t::toolBut 1} -tooltip "Start progress" -state disabled}
            h_ 3
            Img2 {{::t::toolBut 2} -tooltip "Stop progress"}
            sev 7
            h_ 1
            Img5 {{::t::e_menu} -tooltip "Run e_menu"}
            sev 7
            h_ 1
            Img3 {{::t::toolBut 3 \[set ::t::prevcs\]}}
            h_ 1
            opcTool {::t::opcc ::t::opcColors {-width 20} {t::opcToolPre %a} -command t::opcToolPost -tooltip "Current color scheme"}
            h_ 1
            Img4 {{::t::toolBut 4 \[set ::t::nextcs\]}}
            h_ 4
            ChbRestart {-var ::t::restart -t "Restart" -tooltip "To restart test2\nif CS changes"}
            sev 8
            h_ 1
            spX  {-tvar ::t::fontsz -command {::t::toolBut 4 -3} -from 8 -to 16 -w 3 -justify center -tooltip "Font size 8..16" -myown {
              puts "\nA local/global configuration may be set with -myown attribute, e.g.\
              \n  %w configure -bg yellow -font {-weight bold}\
              \n  ::NS::GLOBAL_CONFIG %w"}}
      }}}
      {# remove this comment to view another way to make a statusbar:
       stat - - - - {pack -side bottom} {-array {
            {Row:       -font {-slant italic -size 10}} 7
            {" Column:" -font {-slant italic -size 10}} 5
            {""         -font {-slant italic -size 10}} 30
      }}}
      {lab1 - - - - {pack -pady 0} {-t \
      "It's a bit modified Tk's demos/ttkpane.tcl" -font "-weight bold -size 12"}}
      {lab2 - - - - {pack} {-t "This demonstration shows off a nested set of themed paned windows. Their sizes can be changed by grabbing the area between each contained pane and dragging the divider." -wraplength 4i -justify left}}
      {fra - - - - {pack -side bottom -fill both -expand 1 -pady 0}}
      {fra.pan - - - - {pack -side bottom -fill both -expand 1} {-orient horizontal}}
      {fra.pan.panL - - - - {add} {-orient vertical}}
      {.lfrT - - - - {add} {-t Button}}
      {.lfrT.but - - - - {} {-t "Press Me" -com "t::pdlg ok info {Button Pressed} {That hurt...} -root .win -head {Ouch! Wow!\nMiau!} -weight bold -timeout {5 Lab1}" }}
      {.Lframe - - - - {add} {-t Clocks}}
      {fra.pan.panR - - - - {add} {-orient vertical}}
      {.lfrT - - - - {add} {-t Progress}}
      {.lfrT.Pro - - - - {pack -fill both -expand 1} {-mode indeterminate} {%w start}}
      {.LfrB - - - - {add} {-t "Bar of tabs"}}
      {.lfrB.BtsBar  - - - - {pack -side top -fill x} {::t::fillBarTabs %w}}
      {.lfrB.LabEdit  - - - - {pack -side top -fill x}}
      {.lfrB.stat - - - - {pack -side bottom} {-array {
            {Row:       -font {-slant italic -size 10}} 7
            {" Column:" -font {-slant italic -size 10}} 5
            {""         -font {-slant italic -size 10}} 30
      }}}
      {.lfrB.Text .lfrB.stat T - - {pack -side left -expand 1 -fill both} {-borderwidth 0 -w 80 -h 10 -wrap word -tabnext .win.fra.fral.butHome}}
      {.lfrB.sbv .lfrB.text L - - {pack -side top}}
    } .win.fra.fra.nbk.f3 {

      ####################################################################
      # {#                3RD TAB: ENABLED NON-TTK WIDGETS               }
      ####################################################################
      {fra1 - - 1 1 {-st w}}
      {.laB0  - - 1 1 {-st w} {-t "Enabled widgets"}}
      {.laB  fra1.laB0 T 1 1 {-st w -pady 1} {-t "label" -font "-weight bold -size 11"}}
      {.buTRun fra1.laB T 1 1 {-st w} {-t "button" -com ::t::Pressed} 
        {eval {
          ##################################################################
          # The last element of widget record is Tcl command being the last.
          # executed, i.e. after making the current widget.
          # Here is a definition of procedure that makes a button to blink.
          ##################################################################
          proc ::t::Pressed {} {
            if {[[::t::pave BuTRun] cget -text]!="button"} return
            set bg [[::t::pave BuTRun] cget -background]
            [::t::pave BuTRun] config -text "P R E S S E D"
            for {set i 0} {$i<500} {incr i 100} {
              after $i {[::t::pave BuTRun] config -background #292a2a}
              after [expr $i+50] "[::t::pave BuTRun] config -background $bg"
            }
            after 800 [list [::t::pave BuTRun] config -text button]
          }
        }}}
      {.chB fra1.buTRun T 1 1 {-st w -pady 5} {-t "  checkbutton"}}
      {.frAE fra1.chB T 1 1 {-st w}}
      {.frAE.laB - - 1 1 {-st w} {-t "entry "}}
      {.frAE.enT fra1.frAE.laB L 1 1 {-st w -pady 5} {-tvar t::tv2}}
      {.frA fra1.frAE T 1 1 {-st w}}
      {.frA.laB - - 1 1 {-st w -ipady 5} {-t "label in frame" -font "-weight bold -size 11"}}
      {.lfR fra1.frA T 1 1 {-st w} {-t "labeled frame" -font "-weight bold -size 11"}}
      {.lfR.raD1 - - 1 1 {-st w -pady 5} {-t "radiobutton" -var t::v2 -value 1}}
      {.lfR.raD2 fra1.lfR.raD1 L 1 1 {-st w -padx 7} {-t "radio 2" -var t::v2 -value 2}}
      {.frAS fra1.lfR T 1 1 {-st w -pady 5}}
      {.frAS.laB - - - - {pack -side left -anchor w} {-t "spinbox 1 through 9 "}}
      {.frAS.spX - - - - {pack} {-tvar t::tv -from 1 -to 9 -w 5 -justify center}}
      {.frAsc fra1.frAS T 1 1 {-st ew -pady 5}}
      {.frAsc.laBsc - - - - {pack -side left} {-t "scale 0 through 100 "}}
      {.frAsc.scA - - - - {pack -side right} {-orient horizontal -w 12 -sliderlength 20 -length 238 -var t::sc}}
      {.frALB fra1.frAsc T 1 1}
      {.frALB.laB - - - - {pack -side left -anchor nw} {-t "listbox of colors  "}}
      {.frALB.lbx - - - - {pack -side left -fill x -expand 1} {-lvar t::lvar -h 4 -w 30 -lbxsel dark -ALL yes}}
      {.frALB.sbV fra1.frALB.lbx L - - {pack}}

      ####################################################################
      # {#                   DISABLED NON_TTK WIDGETS                    }
      ####################################################################
      {labFR # # # # # {-t "labeled frame" -font "-weight bold -size 11" -state disabled -foreground gray}}
      {lfR1 fra1 L 1 1 {-st we -cw 1} {-t "Disabled counterparts"}}
      {.laB - - 1 1 {-st w } {-t "label" -font "-weight bold -size 11" -state disabled}}
      {.BuTRun lfR1.laB T 1 1 {-st w} {-t "button" -state disabled}}
      {.chB lfR1.buTRun T 1 1 {-st w -pady 5} {-t " checkbutton" -state disabled}}
      {.frAE lfR1.chB T 1 1 {-st w} {-state disabled}}
      {.frAE.laB - - 1 1 {-st w} {-t "entry " -state disabled}}
      {.frAE.enT lfR1.frAE.laB L 1 1 {-st w -pady 5} {-tvar t::tv2 -state disabled}}
      {.frA lfR1.frAE T 1 1 {-st w} {-state disabled}}
      {.frA.laB - - 1 1 {-st w -ipady 5} {-t "label in frame" -font "-weight bold -size 11" -state disabled}}
      {.lfR lfR1.frA T 1 1 {-st w} {-labelwidget .win.fra.fra.nbk.f3.labFR -font "-weight bold -size 11" -state disabled}}
      {.lfR.raD1 - - 1 1 {-st w -pady 5} {-t "radiobutton" -var t::v2 -value 1 -state disabled}}
      {.lfR.raD2 lfR1.lfR.raD1 L 1 1 {-st w -padx 7} {-t "radio 2" -var t::v2 -value 2 -state disabled}}
      {.frAS lfR1.lfR T 1 1 {-st w -pady 5} {-state disabled}}
      {.frAS.laB - - - - {pack -side left -anchor w} {-t "spinbox 1 through 9 "  -state disabled}}
      {.frAS.spX - - - - {pack} {-tvar t::tv -from 1 -to 9 -w 5 -justify center -state disabled}}
      {.frAsc lfR1.frAS T 1 1 {-st ew -cw 1} {-state disabled}}
      {.frAsc.laBsc - - - - {pack -side left} {-t "scale 0 through 100 " -state disabled}}
      {.frAsc.scA - - - - {pack} {-orient horizontal -w 12 -sliderlength 20 -length 238 -state disabled -var t::sc}}
      {.frALB lfR1.frAsc T 1 1 {-st ew -pady 5} {-state disabled}}
      {.frALB.laB - - - - {pack -side left -anchor nw} {-t "listbox of colors  " -state disabled}}
      {.frALB.lbx - - - - {pack -side left -fill x -expand 1} {-lvar t::lvar -h 4 -w 30 -state disabled}}
      {.frALB.sbV lfR1.frALB.lbx L - - {pack -side left}}

      ####################################################################
      # {#           FRAME FOR TEXT WIDGET OF NON-TTK WIDGET TAB         }
      ####################################################################
      {frAT fra1 T 1 2 {-st nsew -rw 1 -pady 7}}
      {frAT.laB - - - - {pack -side left -anchor nw} {-t "text & scrollbars \
\n\nas above, i.e.\nnot  ttk::scrollbar\n\ntext is read-only"}}
      {frAT.TextNT - - - - {pack -side left -expand 1 -fill both} {-h 5 -wrap none -rotext ::t::filetxt -tabnext .win.fra.fral.butHome}}
      {frAT.sbV frAT.textNT L - - {pack}}
      {frAT.sbH frAT.textNT T - - {pack}}
    } .win.fra.fra.nbk.f4 {
      {can - - - - {pack} {-h 130 -w 360}
        {eval {
          ##################################################################
          # This code is taken from Tk's demos/ctext.tcl
          proc mkTextConfigPie {w x y a option value color} {
            set item [$w create arc $x $y [expr {$x+90}] [expr {$y+90}] \
          	  -start [expr {$a-15}] -extent 30 -fill $color]
          }
          set c .win.fra.fra.nbk.f4.can
          $c create text 180 20 -text {Demo canvas from Tk's demos/ctext.tcl}
          for {set i0 0} {$i0<12} {incr i0} {
            set i1 [expr {$i0*30}]
            set i2 [expr {$i0>9 ? [expr {($i0-10)*30}]: [expr {90+$i1}]}]
            mkTextConfigPie $c 140 30 $i1 -angle  $i2 Yellow
          }
        }}}
      {seh - - - - {pack -pady 7 -fill x}}
      {lab - - - - {pack} {-tvar t::sc2}}
      {sca - - - - {pack} {-length 500 -o horiz -var t::sc -from 0 -to 100}}
      {seh2 - - - - {pack -pady 7 -fill x}}
      {spx - - - - {pack} {-tvar t::tv -from 1 -to 9 -w 5 -justify center}}
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
    } .win.fra.fra.nbk.f5 {

      ####################################################################
      # {#                TAB-5: COLOR SCHEMES                           }
      ####################################################################
      {BuTClrB  - - 1 4 {-st nsew -rw 1 -cw 1} {-com {::t::toolBut 4 -1} -text "Color scheme -1\nBasic"}}
      {tcl {
        set prt BuTClrB
        for {set i 0} {$i<44} {incr i} {
          set cur "BuTClr$i"
          if {$i%4} {set n $pr; set p L} {set n $prt; set p T; set prt $cur}
          set pr $cur
          set lwid "$cur $n $p 1 1 {-st nsew -rw 1 -cw 1} {-com \
           {::t::toolBut 4 $i} -t \"Color scheme $i\n[t::pave csGetName $i]\"}"
          %C $lwid
        }
      }}
    } .win.fra.fra.nbk2.f1 {

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
      {fraflb.butView - - - - {pack -side right -anchor nw -padx 9} {-t "Edit the file" -com t::viewfile -tooltip "Opens a stand-alone editor of the file\nthe listbox' data are taken from."}}
      {fraflb.lab - - - - {pack -side left -anchor nw} {-t "Listbox of file content:  \n\nSee also:\nGeneral/Misc. tab"}}
      {fraflb.flb - - - - {pack -side left -fill x -expand 1} {-lvar ::t::lv1 -lbxsel Cont -ALL 1 -w 50 -h 5 -tooltip "The 'flb' listbox contains:\n 1)  four literal lines\n  2) data from 'test2_fco.dat' file" -values {@@-div1 " \[" -div2 "\] " test2_fco.dat@@   INFO: @@-pos 22 -ret 1 -list {{Content of test2_fco.dat} {another item} trunk DOC} test2_fco.dat@@ Code of test2_pave.tcl: @@-RE {^(\s*)([^#]+)$} ./test2_pave.tcl@@}}}
      {fraflb.sbv fraflb.flb L - - {pack -side left}}
      {fraflb.sbh fraflb.flb T - - {pack -side left}}
    } .win.fra.fra.nbk2.f2 {
      {lab - - - - {pack -expand 1 -fill both} {-t "Some text of 2nd View" \
      -font "-weight bold -size 11"}}
    }

    # text widget's name is uppercased, so we can use the Text method
    set wtex [pave Text]
    # bindings and contents for text widget
    bind $wtex <ButtonRelease> [list t::textPos $wtex]
    bind $wtex <KeyRelease> [list t::textPos $wtex]
    bind $wtex <<Modified>> ::t::tabModified
    pave displayText $wtex $::t::filetxt
    # at first, Ftx1 widget is editable
    pave makePopup [pave Ftx1] no yes
    # we can use the Lframe method to get its name, similar to Text
    fillclock [pave Lframe]

    # 3d frame - "Options" (not too much efforts applied ;^)
    set lst3 {
      {but1 -    - 1 1 {-st we} {-t "Options1" -com "t::pdlg ok info O1 Opts1..."}}
      {but2 but1 T 1 1 {-st we} {-t "Options2" -com "t::pdlg ok ques O2 Opts2..."}}
      {but3 but2 T 1 1 {-st we} {-t "Options3" -com "t::pdlg ok warn O3 Opts3..."}}
      {but4 but3 T 1 1 {-st we} {-t "Options4" -com "t::pdlg ok err  O4 Opts4..."}}
      {but5 but1 L 1 1 {-st we} {-t "more..."  -com "t::pdlg ok info M  More..."}}
    }
    foreach b {6 7 8 9 a b c d e f g h i} p {5 6 7 8 9 a b c d e f g h} {
      lappend lst3 [list but$b but$p T 1 1 {-st we} \
        {-t "more..." -com "t::pdlg ok warn M More...[incr ::iMORE] -text 1 -w 10"}]
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
    for {set i 0} {$i<44} {incr i} {
      lassign [pave csGet $i] - fg - bg
      [pave BuTClr$i] configure -foreground $fg -background $bg
    }

    # icons of top toolbar
    for {set i 0} {$i<[llength $imgl]} {incr i} {
      [pave BuT_Img[expr {$i+$imgused}]] configure -command \
        [list ::t::msg info "This is just a demo.\nIcon $i: [lindex $imgl $i]"]
    }

    # filling the menu
    after idle [list ::t::fillMenu]

    # filling the bar of tabs (another way, instead of btsBar widget)
    # after idle [list ::t::fillBarTabs [pave BtsBar]]

    if {$firstin} {
      set ::t::nextcs [apave::cs_Min]
      set ::t::prevcs [apave::cs_Max]
    } else {
      set ::t::nextcs [expr {$::t::newCS==[apave::cs_Max] ? \
        [apave::cs_Min] : $::t::newCS+1}]
      set ::t::prevcs [expr {$::t::newCS==[apave::cs_Min] ? \
        [apave::cs_Max] : $::t::newCS-1}]
      toolBut 4 $::t::newCS yes
      if {$t::ans4==11} {[pave ChbRestart] configure -state disabled}
    }
    set ::t::newCS [apave::cs_Non]
    toolBut 0

    # Open the window at last
    set ::t::curTab ""
    chanTab nbk
    set res [pave showModal .win -geometry +300+20 -decor 1 -onclose t::exitProc]
    if {$::t::newCS==[apave::cs_Non]} { ;# at restart, newCS is set
      # getting result and clearance
      set res [pave res .win]
      puts "
    text file name = \"$::t::ftx1\"
    text file contents =
-------------------------------
[pave getTextContent ::t::ftx1]
-------------------------------
    v   = $t::v
    v2  = $t::v2
    c1  = $t::c1
    c2  = $t::c2
    c3  = $t::c3
    cb3 = \"$t::cb3\"
    en1 = \"$t::en1\"
    en2 = \"$t::en2\"
    fil1= \"$t::fil1\"
    fis1= \"$t::fis1\"
    dir1= \"$t::dir1\"
    fon1= \"$t::fon1\"
    clr1= $t::clr1
    dat1= $t::dat1

    lvar ALL: $t::lvar

    lv1 ALL: $t::lv1

    tblWid1 curselection: [lindex $::t::tbllist 0]
    tblWid1 curitem     : [lindex $::t::tbllist 1]
    tblWid1 items       : [lindex $::t::tbllist 2]
    "
    }
    destroy .win
    pave destroy
    pdlg destroy
    return $res
  }

# ________________ Handlers for Help, Apply, Cancel etc. ________________ #

  # imitating help function
  proc helpProc {} {
    if {$t::ans0<10} {
      set t::ans0 [lindex [pdlg ok info "HELP" "\nViewing help...\n" \
        -ch "Don't show again"] 0]
    }
  }

  # imitating apply function
  proc applyProc {} {
    if {$t::ans1<10} {
      set t::ans1 [lindex [pdlg ok info "APPLY" "\nApplying changes...\n" \
        -ch "Don't show again"] 0]
    }
  }

  # imitating cancel function
  proc cancelProc {} {
    if {$t::ans2<10} {
      set t::ans2 [lindex [pdlg yesnocancel warn "CANCEL" \
        "\nDiscard all changes?\n" NO -ch "Don't show again"] 0]
      if {$t::ans2==1 || $t::ans2==11} {
        pave res .win 0
      }
    }
  }

  # imitating save & exit function
  proc okProc {} {
    ::t::pdlg ok info "SAVE" "Saving changes...\nCurtain." -weight bold -size 16
    pave res .win 1
  }

  proc restartHint {cs} {
    return "\nRestart with CS = \"$cs [pave csGetName $cs]\", font size = [t::pave basicFontSize] ?\nIt's a good choice, as the CS would be properly set up.\n"
  }

  # imitating the toolbar functions
  proc toolBut {num {cs -2} {starting no}} {
    if {$num in {3 4}} {
      [pave Menu] entryconfigure 2 -font {-slant roman -size 10}
    } elseif {$num == 2} {
      [pave Pro] stop
      [pave BuT_Img2] configure -state disabled
      [pave BuT_Img1] configure -state normal
    } elseif {$num == 1} {
      [pave Pro] start
      [pave BuT_Img1] configure -state disabled
      [pave BuT_Img2] configure -state normal
    }
    [pave Menu] entryconfig 2 -state [[pave BuT_Img2] cget -state] ;# for fun
    [pave File] entryconfig 2 -state [[pave BuT_Img2] cget -state]
    [pave File] entryconfig 3 -state [[pave BuT_Img2] cget -state]
    if {$num in {3 4}} {
      if {$num == 3} {set cs $::t::prevcs}
      if {$num == 4 && $cs==-2} {set cs $::t::nextcs}
      if {$num == 4 && $cs==-3} {
        if {[set cs [pave csCurrent]]<[apave::cs_Min]} {set cs [apave::cs_Min]}
        pave basicFontSize $::t::fontsz
      }
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
        set ::t::prevcs [apave::cs_Max]
      }
      if {$cs<[apave::cs_Max]} {
        set ::t::nextcs [expr {$cs+1}]
      } else {
        set ::t::nextcs [apave::cs_Min]
      }
      set ic [expr {$cs>20 ? 3 : 2}]  ;# "|" was added
      set ::t::opcc [pave optionCascadeText [lindex $::t::opcColors $cs+$ic]]
      .win.fra.fra.nbk tab .win.fra.fra.nbk.f5 -text \
      " Color scheme $cs: [pave csGetName $cs]"
      catch {::t::colorBar}
    }
    tooltip::tooltip [pave BuT_Img4] \
      "Next is $::t::nextcs: [pave csGetName $::t::nextcs]"
    tooltip::tooltip [pave BuT_Img3] \
      "Previous is $::t::prevcs: [pave csGetName $::t::prevcs]"
    lassign [pave csGet] fg - bg - - bS fS
    set ::t::textTags [list [list "red" " -font {-weight bold} \
      -foreground $fS -background $bS"]]
    if {$t::ans4==12} {
      set ::t::restart 0
      [pave ChbRestart] configure -state disabled
    }
  }

  # ask about exiting
  proc exitProc {resExit} {
    upvar $resExit res
    if {[::t::pdlg yesno ques "EXIT" "\nClose the test?\n" NO]==1} {
      set res 0
    }
  }

  # changing the current tab: we need to save the old tab's selection
  # in order to restore the selection at the tab's return.
  proc chanTab {tab} {
    if {$tab != $::t::curTab} {
      if {$::t::curTab !=""} {
        set arrayTab($::t::curTab) [.win.fra.fra.$::t::curTab select]
        pack forget .win.fra.fra.$::t::curTab
      }
      set ::t::curTab $tab
      pack .win.fra.fra.$::t::curTab -expand yes -fill both
      catch {
        .win.fra.fra.$::t::curTab select $arrayTab($::t::curTab)
      }
    }
  }

  # displaying the cursor position and the current line's contents
  proc textPos {txt} {
    lassign [split [$txt index insert] .] r c
    [pave Labstat1] configure -text $r
    [pave Labstat2] configure -text [incr c]
    [pave Labstat3] configure -text [$txt get \
      [$txt index "insert linestart"] [$txt index "insert lineend"]]
  }
  # filling the menu
  proc fillMenu {} {
    set m .win.menu.file
    $m add command -label "Open..." -command {::t::msg info "this is just a demo:\nno action has been defined for the \"Open...\" entry"}
    $m add command -label "New" -command {::t::msg info "this is just a demo:\nno action has been defined for the \"New\" entry"}
    $m add command -label "Save" -command {::t::msg info "this is just a demo:\nno action has been defined for the \"Save\" entry"}
    $m add command -label "Save As..." -command {::t::msg info "this is just a demo:\nno action has been defined for the \"Save As...\" entry"}
    $m add separator
    $m add command -label "Restart" -command {::t::restartit}
    $m add separator
    $m add command -label "Quit" -command {::t::pave res .win 0}
    set m .win.menu.edit
    $m add command -label "Cut" -command {::t::msg ques "this is just a demo: no action"}
    $m add command -label "Copy" -command {::t::msg warn "this is just a demo: no action"}
    $m add command -label "Paste" -command {::t::msg err "this is just a demo: no action"}
    $m add separator
    $m add command -label "Reload the bar of tabs" -command {::t::RefillBar}
    set m .win.menu.help
    $m add command -label "About" -command [list ::t::msg info "  It's a demo of\n  <red> $::pkg_versions </red> packages.\n\n  Details: \

  https://aplsimple.github.io/en/tcl/pave
  https://aplsimple.github.io/en/tcl/bartabs

  License: MIT.
  _______________________________________

  <red> $::tcltk_version </red>

  <red> $::tcl_platform(os) $::tcl_platform(osVersion) </red>
" -t 1 -w 46 -tags ::t::textTags]
  }

  proc tracer {varname args} {
    set ::t::sc2 [expr round($::t::sc)]
  }
  
  proc viewfile {} {
    set res [::t::pdlg vieweditFile test2_fco.dat "" -w 74 -h 20 -ro 0 -rotext ::temp]
    puts "\n------------\nResult: $res.\nContent:\n$::temp\n------------\n"
    unset ::temp
  }
  
  proc msg {icon message args} {
    ::t::pdlg ok $icon [string toupper $icon] "\n$message\n" {*}$args
  }

  proc restartit {} {
    if {[set cs [pave csCurrent]]==[apave::cs_Non]} {set cs [apave::cs_Min]}
    if {[::t::pdlg yesno warn "RESTART" [restartHint $cs]]} {
      pave res .win [set ::t::newCS $cs]
    }
  }

  proc e_menu {{fname ""}} {
    if {[info commands ::em::main] ne ""} {
      if {$fname eq ""} {set fname $::t::ftx1}
      lassign [split [winfo geometry .win] x+] w h x y
      set geo "350x1+[expr {$w+$x-350}]+$y"
      set cs [pave csCurrent]
      ::em::main -prior 1 -modal 1 -remain 0 "md=~/.tke/plugins/e_menu/menus" m=menu.mnu "f=$fname" "PD=~/PG/e_menu_PD.txt" "s=none" b=chromium h=~/DOC/www.tcl.tk/man/tcl8.6 "tt=xterm -fs 12 -geometry 90x30+400+100" w=32 g=$geo om=0 c=$cs dk=dock
      set cs2 [pave csCurrent]
      if {$cs!=$cs2} {toolBut 4 $cs2}
    } else {
      ::t::pdlg ok $icon ERROR " Not found e_menu.tcl in directory:\n $::e_menu_dir" -t 1
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
    set cs [string range $::t::opcc 0 [string first ":" $::t::opcc]-1]
    if {$cs ne ""} {toolBut 4 $cs}
  }

# ____________________ Procedures for bartabs widget ____________________ #

  # filling the bar of tabs
  proc fillBarTabs {wframe {swredraw false}} {
    if {![info exists ::BTS_REDRAW]} {set ::BTS_REDRAW 1}
    if {$swredraw} {set ::BTS_REDRAW [expr {[incr ::BTS_REDRAW]%2}]}
    set ::t::noname "<No name>"
    set ::t::ansSelTab [set ::t::ansSwBta 0]
    set wbase [pave LfrB]
    set bar1Opts [list -wbar $wframe -wbase $wbase -lablen 16 \
      -csel {::t::selTab %t} -cdel {::t::delTab %t} -redraw $::BTS_REDRAW \
      -menu [list \
      sep \
      "com {Mark the tab} {::t::markTab %t} {} ::t::checkMark" \
      "com {Append $::t::noname} {::t::addTab %t} {} ::t::checkStatic" \
      "com {View selected} {::t::ViewSelTabs %b} {} {{!\[::bt isTab %t\]} Img20}" \
      {com {Unselect all} {::bt unselectTab} {} {{![::bt isTab %bt]} Img22}} \
      sep \
      {com {Run %l} {::t::e_menu [::t::getTabFile %t]} {} {{![::bt isTab %t]} Img17 {} F5}} \
      sep \
      "mnu {Options} {} menusw {0 Img25}" \
      "com {Switch -static option} {::t::switchBts %b %t -static} menusw ::t::switchAtt" \
      "com {Switch -scrollsel option} {::t::switchBts %b %t -scrollsel} menusw ::t::switchAtt" \
      "com {Switch -hidearrows option} {::t::switchBts %b %t -hidearrows} menusw ::t::switchAtt" \
      "com {Switch -expand option} {::t::switchBts %b %t -expand} menusw ::t::switchAtt" \
      "com {Switch -bd option} {::t::switchBts %b %t -bd} menusw ::t::switchAtt" \
      "sep {} {} menusw" \
      "mnu {Others} {} menusw.oth" \
      "com {Switch -redraw option} {::t::RefillBar yes} menusw.oth ::t::switchAtt" \
      "com {Switch -lablen option} {::t::switchBts %b %t -lablen} menusw.oth ::t::switchAtt" \
      "com {Switch -fgsel option} {::t::switchBts %b %t -fgsel} menusw.oth ::t::switchAtt" \
      "com {Switch -imagemark option} {::t::switchBts %b %t -imagemark} menusw.oth ::t::switchAtt" \
      "com {Switch -padx} {::t::switchBts %b %t -padx} menusw.oth ::t::switchAtt" \
      "com {Switch -pady} {::t::switchBts %b %t -pady} menusw.oth ::t::switchAtt" \
      ]]
    set ::t::tclfiles [list]
    foreach dirname $::test2dirs {
      foreach f [glob [file join $dirname *.tcl]] {
        set f [file normalize $f]
        set fname [file tail $f]
        if {[lsearch -index 0 $::t::tclfiles $fname]>-1} {
          set fname [file join {*}[lrange [file split $f] end-1 end]]
        }
        lappend ::t::tclfiles [list $fname $f]
      }
    }
    foreach ff [set ::t::tclfiles [lsort -index 0 $::t::tclfiles]] {
      set tab [lindex $ff 0]
      if {[string match "bart*" $tab]} {
        lappend bar1Opts -imagetab [list $tab Img45]
      } else {
        lappend bar1Opts -tab $tab
      }
    }
    bartabs::Bars create ::bts                ;# ::bts is Bars object
    set ::t::BID [::bts create ::bt $bar1Opts]  ;# ::bt is Bar object
    set ::t::ftx1 $::t::ftx0
    ::bt [::bt tabID [file tail $::t::ftx1]] show
    bind [pave Text] <Control-Left> "::bt scrollLeft ; break"
    bind [pave Text] <Control-Right> "::bt scrollRight ; break"
    bind .win <F5> "::t::e_menu; break"
    colorBar
  }

  proc colorBar {} {
    set cs [pave csCurrent]
    if {$cs>-1} {
      lassign [pave csGet $cs] cfg2 cfg1 cbg2 cbg1 cfhh - - - - fgmark
    } else {
      set fgmark #168080
    }
    ::bt configure -fgmark $fgmark
    ::bt draw
  }

  proc getTabFile {TID} {
    set label [::bts $TID cget -text]
    set i [lsearch -index 0 $::t::tclfiles $label]
    return [lindex $::t::tclfiles $i 1]
  }

  proc selTab {TID} {
    set tcurr [::bt cget -tabcurrent]
    if {$tcurr in [::bt cget -mark] && $::t::ansSelTab<10} {
      set fname [getTabFile $tcurr]
      set ::t::ansSelTab [msg warn "The file $fname was marked.\nThere might be some actions taken before quitting it.\n\nHere the mark is removed if \"Don't show again\" is off.\nThe mark is also removed after selecting a tab." -ch "Don't show again" -modal 0]
      if {$::t::ansSelTab<10} {::bts unmarkTab $tcurr}
    }
    set ::t::ftx1 [getTabFile $TID]
    set ::t::filetxt [::apave::readTextFile $::t::ftx1]
    pave displayText [pave Text] $::t::filetxt
    [pave LabEdit] configure -text "$::t::ftx1" -padding {2 8 0 2}
    ::bts unmarkTab $TID
    return yes
  }

  proc delTab {TID} {
    set fname [getTabFile $TID]
    ;# just to play with BID (::bt is less wordy):
    set BID [::bts $TID cget -BID]
    if {$TID in [::bts $BID cget -mark]} {
      msg warn "The file $fname was modified.\nThere might be some actions taken before its closing.\n\nThe test is just rejecting the closing.\nPress Ctrl+Z to undo and then close the file."
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
    set newTID [::bt insertTab $::t::noname end Img32]
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
    return {0 Img32}
  }

  proc checkMark {BID TID label} {
    if {[::bt cget -static]} {return 2}
    set res [checkStatic]
    if {$TID in [::bt cget -mark]} {
      set label [string map {Mark Unmark} $label]
      set img Img13
    } else {
      set label [string map {Unmark Mark} $label]
      set img ""
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

  proc switchAtt {BID TID label} {
    lassign $label -> opt
    switch -- $opt {
      -static - -scrollsel - -hidearrows - -expand - -bd - -redraw {
        if {[::bt cget $opt]} {set img Img30} {set img Img31}
        set res [list 0 $img]
      }
      -lablen - -fgsel - -pady - -padx {
        set val [::bt cget $opt]
        set res [list 0 "" "$label ($val)"]
      }
      -imagemark {
        if {[::bt cget -static]} {return 2}
        if {[::bt cget $opt] eq ""} {set img ""} {set img Img13}
        set res [list 0 $img]
      }
      default {set res 0}
    }
    return $res
  }

  proc switchBts {BID TID optname args} {
    set val [::bt cget $optname]
    switch -- $optname {
      -bd     {if {!$val} {set val 1} {set val 0}}
      -lablen {if {!$val} {set val 16} {set val 0}}
      -fgsel  {if {$val eq ""} {set val "."} else {set val ""}}
      -pady - -padx {if {$val==10} {set val 3} else {set val 10}}
      -imagemark {if {$val eq ""} {set val "Img13"} else {set val ""}}
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
  }

} ;# end of ::t namespace

# __________________________ Running the test ___________________________ #

puts "\nThis is just a demo. Take it easy."
set test2script $::t::ftx1
apave::initWM
if {$::argc==3} {
  lassign $::argv ::t::newCS ::t::fontsz t::ans4
} else {
  set ::t::newCS [apave::cs_Non]
}
set test2res [t::test2_pave]
puts "\nResult of test2 = $test2res\n[string repeat - 77]"
if {$::t::newCS!=[apave::cs_Non]} {  ;# at restart, newCS is set
  exec tclsh $test2script $::t::newCS $::t::fontsz $t::ans4 &
}
apave::APaveInput destroy
namespace delete apave
namespace delete t
exit
