#! /usr/bin/env wish

###########################################################################
#
# Test 2 demonstrates a bit more complex dialog "Preferences".
# Note how the pave is applied to the frames of notebook.
#
###########################################################################

package require Tk
catch {package require tooltip} ;# may be absent

lappend auto_path ".."; package require apave

namespace eval t {

  source [file join [file dirname [info script]] test2_img.tcl]

  # variables used in layouts
  variable v 1 v2 1 c1 0 c2 0 c3 0 en1 "" en2 "" tv 1 tv2 "enter value" sc 0 sc2 0 cb3 "Content of test2_fco.dat" lv1 {}
  variable fil1 "" fis1 "" dir1 "" clr1 "" fon1 "" dat1 "" ftx1 ""
  variable ans0 0 ans1 0 ans2 0 ans3 0
  variable lvar {white blue "dark red" black #112334 #fefefe
  "sea green" "hot pink" cyan aqua "olive drab" snow wheat  }
  variable arrayTab
  variable pdlg
  variable pave

# This code is taken from Tk's demos/ttkpane.tcl
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

  #########################################################################
  # test's main proc

  proc test2 {} {

    apave::initWM
    set ::t::ftx1 $::argv0
    variable pdlg
    variable pave
    apave::APaveInput create pdlg .win
    apave::APaveInput create pave .win
    set ::t::filetxt [pave readTextFile $::t::ftx1]
    set ::t::tblcols {
      0 {Name of widget} left \
      0 Type left \
      0 X right \
      0 Y right
    }
    set ::t::tbllist {
      {"but" "ttk::button" 1 1}
      {"buT" "button" 2 2}
      {"can" "canvas" 3 3}
      {"chb" "ttk::checkbutton" 4 4}
      {"chB" "checkbutton" 5 5}
      {"cbx fco" "ttk::combobox" 23 2}
      {"ent" "ttk::entry" 212 6}
      {"enT" "entry" 45 7}
      {"fil" - 1 0}
      {"fis" - 2 0}
      {"dir" - 3 0}
      {"fon" - 4 0}
      {"clr" - 5 0}
      {"dat" - 6 0}
      {"sta" - 7 0}
      {"too" - 8 0}
      {"fra" "ttk::frame" 9 0}
      {"ftx" "ttk::labelframe" 1234 6}
      {"frA" "frame" 11 22}
      {"lab" "ttk::label" 77 8}
      {"laB" "label" 3 5}
      {"lfr" "ttk::labelframe" 7 88}
      {"lfR" "labelframe" 9 00}
      {"lbx flb" "listbox" 99 89}
      {"meb" "ttk::menubutton" 5 7}
      {"meB" "menubutton" 7 89}
      {"not" "ttk::notebook" 8 654}
      {"pan" "ttk::panedwindow" 324 6}
      {"pro" "ttk::progressbar" 2 5}
      {"rad" "ttk::radiobutton" 8 765}
      {"raD" "radiobutton" 4 21}
      {"sca" "ttk::scale" 1 23}
      {"scA" "scale" 43 6}
      {"sbh" "ttk::scrollbar" 98 7}
      {"sbH" "scrollbar" 543 245}
      {"sbv" "ttk::scrollbar" 98 65}
      {"sbV" "scrollbar" 43 578}
      {"seh" "ttk::separator" 98 32}
      {"sev" "ttk::separator" 34 7}
      {"siz" "ttk::sizegrip" 863 867}
      {"spx" "ttk::spinbox" 78 654}
      {"spX" "spinbox" 98 212}
      {"tbl" "tablelist::tablelist" 435 76}
      {"tex" "text" 87 333}
      {"tre" "ttk::treeview" 86 2}
      {"h_*" "horizontal spacer" 98 3223}
      {"v_*" "vertical spacer" 356 79}
    }
    set ilv 0
    foreach lv $::t::tbllist {
      lassign $lv - - l2 l3
      set ::t::tbllist [lreplace $::t::tbllist $ilv $ilv [lreplace $lv 2 3 \
        [string range "000$l2" end-3 end]  [string range "000$l3" end-3 end]]]
      incr ilv
    }
    variable arrayTab
    array set arrayTab {}
    # initializing images for toolbar
    foreach {I i} {i 1 i 2 I 3 I 4} {
      image create photo ${I}mg$i -data [set t::img${i}_b64]
    }
    set ::bgst [ttk::style lookup TScrollbar -troughcolor]
    ttk::style conf TLabelframe -labelmargins {5 10 1 1} -relief ridge -padding 4
    trace add variable t::sc write "::t::tracer ::t::sc"

    # making main window object and dialog object
    pave configure edge "@@"
    pave makeWindow .win "Preferences"

    # before general layout, make the notebook
    ttk::frame .win.fNB
    ttk::notebook .win.fNB.nb
    ttk::notebook .win.fNB.nb2
    ttk::notebook::enableTraversal .win.fNB.nb

    # 1st frame - "General"
    .win.fNB.nb add [ttk::frame .win.fNB.nb.f1] -text " 1st tab of General "
    .win.fNB.nb add [ttk::frame .win.fNB.nb.f2] -text " ttk::panewindow "
    .win.fNB.nb add [ttk::frame .win.fNB.nb.f3] -text " Non-themed "
    .win.fNB.nb add [ttk::frame .win.fNB.nb.f4] -text " Misc. "
    # 2nd frame - "View"
    .win.fNB.nb2 add [ttk::frame .win.fNB.nb2.f1] -text "First of View"
    .win.fNB.nb2 add [ttk::frame .win.fNB.nb2.f2] -text "Second of View"

    pave window .win.fNB.nb.f1 {

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
            help "&{Help (wordy-fonty)} -state disabled -font {-slant italic -size 10} -menu .win.menu"
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
      {ftx1 labBftx1 L 1 9 {} {-h 7 -ro 0 -tvar ::t::ftx1 -title {Pick a file to view} -filetypes {{{Tcl scripts} .tcl} {{Text files} {.txt .test}}} -wrap word -tooltip "After choosing a file\nthe text will be read-only." -tabnext "[my Tbl1]"}}
      {labtbl1 labBftx1 T 1 1 {-st e} {-t "Tablelist widget:"}}
      {frAT labtbl1 L 1 9 {-st ew -pady 15}}
      {frAT.Tbl1 - - - - {pack -side left -fill x -expand 1} {-h 7 -lvar ::t::tbllist  -lbxsel but -columns {$::t::tblcols}}}
      {frAT.sbv frAT.tbl1 L - - {pack}}
      {labB4 labtbl1 T 3 9 {-st ewns -rw 1} {-t "Some others options can be below"}}
    } .win.fNB.nb.f2 {

      ####################################################################
      # {#               2ND TAB (DEMO OF ttk::panewindow)               }
      ####################################################################
      {tool - - - - {pack -side top} {-array {
            img1 {"::t::toolButt 1" -tooltip "Start progress"}
            h_ 3
            img2 {"::t::toolButt 2" -tooltip "Stop progress"}
            sev 7
            Img3 {"::t::toolButt 3" -tooltip "Restore initial theme" -state disabled}
            h_ 1
            Img4 {"::t::toolButt 4" -tooltip "Change theme"}
      }}}
      {stat - - - - {pack -side bottom} {-array {
            {Row:  -foreground #004080 -background $::bgst -font {-slant italic -size 10}} 7
            {" Column:"  -foreground #004080 -background $::bgst -font {-slant italic -size 10}} 5
            {"" -foreground #004080 -background $::bgst -font {-slant italic -size 10}} 30
      }}}
      {lab1 - - - - {pack -pady 7} {-t \
      "It's a bit modified Tk's demos/ttkpane.tcl" -font "-weight bold -size 12"}}
      {lab2 - - - - {pack} {-t "This demonstration shows off a nested set of themed paned windows. Their sizes can be changed by grabbing the area between each contained pane and dragging the divider." -wraplength 4i -justify left}}
      {fra - - - - {pack -side bottom -fill both -expand 1 -pady 4}}
      {fra.pan - - - - {pack -side bottom -fill both -expand 1} {-orient horizontal}}
      {fra.pan.panL - - - - {} {-orient vertical} {add}}
      {.lfrT - - - - {} {-t Button} {add}}
      {.lfrT.but - - - - {} {-t "Press Me" -com "t::pdlg ok info {Button Pressed} {That hurt...} -root .win -head {Ouch! Wow!\nMiau!} -weight bold" }}
      {.Lframe - - - - {} {-t Clocks} {add}}
      {fra.pan.panR - - - - {} {-orient vertical} {add}}
      {.lfrT - - - - {} {-t Progress} {add}}
      {.lfrT.Pro - - - - {pack -fill both -expand 1} {-mode indeterminate} {} {~ start}}
      {.lfrB - - - - {} {-t "Text of $::t::ftx1"} {add} {}}
      {.lfrB.Text - - - - {pack -side left -expand 1 -fill both} {-borderwidth 0 -w 76 -wrap word -tabnext .win.fral.butGen}}
      {.lfrB.sbv .lfrB.text L - - {pack}}
    } .win.fNB.nb.f3 {

      ####################################################################
      # {#                3RD TAB: ENABLED NON-TTK WIDGETS               }
      ####################################################################
      {fra1 - - 1 1 {-st w}}
      {.laB0  - - 1 1 {-st w} {-t "Enabled widgets"}}
      {.laB  fra1.laB0 T 1 1 {-st w -pady 7} {-t "label" -font "-weight bold -size 11"}}
      {.buT fra1.laB T 1 1 {-st w} {-t "button" -w 10 -comm ::t::Pressed}
        {} {eval {
          puts "This is just a demo. Take it easy."
          ##################################################################
          # The last element of widget record is Tcl command being the last.
          # executed, i.e. after making the current widget.
          # HERE we have a demo procedure (for previous -comm option)
          ##################################################################
          proc ::t::Pressed {} {
            if {[[::t::pave BuTdis] cget -text]!="button"} return
            set bg [[::t::pave BuTdis] cget -background]
            [::t::pave BuTdis] config -text "P R E S S E D"
            for {set i 0} {$i<500} {incr i 100} {
              after $i {[::t::pave BuTdis] config -background #292a2a}
              after [expr $i+50] "[::t::pave BuTdis] config -background $bg"
            }
            after 800 [list [::t::pave BuTdis] config -text button]
          }
        }}}
      {.chB fra1.buT T 1 1 {-st w -pady 7} {-t "  checkbutton"}}
      {.frAE fra1.chB T 1 1 {-st w}}
      {.frAE.laB - - 1 1 {-st w} {-t "entry "}}
      {.frAE.enT fra1.frAE.laB L 1 1 {-st w -pady 7} {-tvar t::tv2}}
      {.frA fra1.frAE T 1 1 {-st w}}
      {.frA.laB - - 1 1 {-st w -ipady 7} {-t "label in frame" -font "-weight bold -size 11"}}
      {.lfR fra1.frA T 1 1 {-st w} {-t "labeled frame" -font "-weight bold -size 11"}}
      {.lfR.raD1 - - 1 1 {-st w -pady 7} {-t "radiobutton" -var t::v2 -value 1}}
      {.lfR.raD2 fra1.lfR.raD1 L 1 1 {-st w -padx 7} {-t "radio 2" -var t::v2 -value 2}}
      {.frAS fra1.lfR T 1 1 {-st w -pady 17}}
      {.frAS.laB - - - - {pack -side left -anchor w} {-t "spinbox 1 through 9 "}}
      {.frAS.spX - - - - {pack} {-tvar t::tv -from 1 -to 9 -w 5 -justify center}}
      {.frAsc fra1.frAS T 1 1 {-st ew -pady 7}}
      {.frAsc.laBsc - - - - {pack -side left} {-t "scale 0 through 100 "}}
      {.frAsc.scA - - - - {pack -side right} {-orient horizontal -w 12 -sliderlength 20 -length 238 -var t::sc}}
      {.frALB fra1.frAsc T 1 1}
      {.frALB.laB - - - - {pack -side left -anchor nw} {-t "listbox of colors  "}}
      {.frALB.lbx - - - - {pack -side left -fill x -expand 1} {-lvar t::lvar -h 5 -w 30 -lbxsel dark}}
      {.frALB.sbV fra1.frALB.lbx L - - {pack}}

      ####################################################################
      # {#                   DISABLED NON_TTK WIDGETS                    }
      ####################################################################
      {labFR # # # # # {-t "labeled frame" -font "-weight bold -size 11" -state disabled -foreground gray}}
      {lfr1 fra1 L 1 1 {-st we -cw 1} {-t "Disabled counterparts"}}
      {.laB - - 1 1 {-st w } {-t "label" -font "-weight bold -size 11" -state disabled}}
      {.BuTdis lfr1.laB T 1 1 {-st w} {-t "button" -w 10 -state disabled}}
      {.chB lfr1.buTdis T 1 1 {-st w -pady 7} {-t " checkbutton" -state disabled}}
      {.frAE lfr1.chB T 1 1 {-st w} {-state disabled}}
      {.frAE.laB - - 1 1 {-st w} {-t "entry " -state disabled}}
      {.frAE.enT lfr1.frAE.laB L 1 1 {-st w -pady 7} {-tvar t::tv2 -state disabled}}
      {.frA lfr1.frAE T 1 1 {-st w} {-state disabled}}
      {.frA.laB - - 1 1 {-st w -ipady 7} {-t "label in frame" -font "-weight bold -size 11" -state disabled}}
      {.lfR lfr1.frA T 1 1 {-st w} {-labelwidget .win.fNB.nb.f3.labFR -font "-weight bold -size 11" -state disabled}}
      {.lfR.raD1 - - 1 1 {-st w -pady 7} {-t "radiobutton" -var t::v2 -value 1 -state disabled}}
      {.lfR.raD2 lfr1.lfR.raD1 L 1 1 {-st w -padx 7} {-t "radio 2" -var t::v2 -value 2 -state disabled}}
      {.frAS lfr1.lfR T 1 1 {-st w -pady 17} {-state disabled}}
      {.frAS.laB - - - - {pack -side left -anchor w} {-t "spinbox 1 through 9 "  -state disabled}}
      {.frAS.spX - - - - {pack} {-tvar t::tv -from 1 -to 9 -w 5 -justify center -state disabled}}
      {.frAsc lfr1.frAS T 1 1 {-st ew -cw 1} {-state disabled}}
      {.frAsc.laBsc - - - - {pack -side left} {-t "scale 0 through 100 " -state disabled}}
      {.frAsc.scA - - - - {pack} {-orient horizontal -w 12 -sliderlength 20 -length 238 -state disabled -var t::sc}}
      {.frALB lfr1.frAsc T 1 1 {-st ew -pady 7} {-state disabled}}
      {.frALB.laB - - - - {pack -side left -anchor nw} {-t "listbox of colors  " -state disabled}}
      {.frALB.lbx - - - - {pack -side left -fill x -expand 1} {-lvar t::lvar -h 5 -w 30 -state disabled}}
      {.frALB.sbV lfr1.frALB.lbx L - - {pack -side left}}

      ####################################################################
      # {#           FRAME FOR TEXT WIDGET OF NON-TTK WIDGET TAB         }
      ####################################################################
      {frAT fra1 T 1 2 {-st nsew -rw 1 -pady 7}}
      {frAT.laB - - - - {pack -side left -anchor nw} {-t "text & scrollbars \
\n\nas above, i.e.\nnot  ttk::scrollbar\n\ntext is read-only"}}
      {frAT.TextNT - - - - {pack -side left -expand 1 -fill both} {-h 11 -wrap none -rotext ::t::filetxt -tabnext .win.fral.butGen}}
      {frAT.sbV frAT.textNT L - - {pack}}
      {frAT.sbH frAT.textNT T - - {pack}}
    } .win.fNB.nb.f4 {
      {can - - - - {pack} {-h 160 -w 360}
        {} {eval {
          ##################################################################
          # This code is taken from Tk's demos/ctext.tcl
          proc mkTextConfigPie {w x y a option value color} {
            set item [$w create arc $x $y [expr {$x+90}] [expr {$y+90}] \
          	  -start [expr {$a-15}] -extent 30 -fill $color]
          }
          set c .win.fNB.nb.f4.can
          $c create text 180 30 -text {Demo canvas from Tk's demos/ctext.tcl}
          for {set i0 0} {$i0<12} {incr i0} {
            set i1 [expr {$i0*30}]
            set i2 [expr {$i0>9 ? [expr {($i0-10)*30}]: [expr {90+$i1}]}]
            mkTextConfigPie $c 140 70 $i1 -angle  $i2 Yellow
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
  -values {TEXT1 @@-div1 \" <\" -div2 > -ret true test1.txt@@ TEXT2 @@-pos 0 -len 7 -list {a b c} test2.txt@@ ...}
where:
  TEXT1, TEXT2, ... TEXTN - optional text snippets outside of @@ ... @@ data sets
  @@ ... @@ - data set for a file, containing the file name and (optionally) its preceding options:
      -div1, -div2 - dividers to filter file lines and to cut substrings from them:
          if -div1 omitted, from the beginning; if -div2 omitted, to the end of line
      -pos, -len - position and length of substring to cut:
          if -pos omitted, -len characters from the beginning; if -len omitted, to the end of line
      -list - a list of items to put directly into the combobox
      -ret - if set to true, means that the field is returned instead of full string
  If there is only a single data set and no TEXT, the @@ marks may be omitted. The @@ marks are configured."}}
      {v_3 - - - - {pack} {-h 3}}
      {fco - - - - {pack} {-tvar t::cb3 -w 88 -tooltip "The \"fco\" combobox contains:\n 1)  four literal lines\n  2) data from 'test2_fco.dat' file" -values {COMMIT: @@-div1 " \[" -div2 "\] " -ret true test2_fco.dat@@   INFO: @@-pos 22 -list {{Content of test2_fco.dat} {another item} trunk DOC} test2_fco.dat@@}}}
      {siz - - - - {pack -side bottom -anchor se}}
    } .win.fNB.nb2.f1 {

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
      {frAflb v_ T 1 5 {-st ew -pady 10} {-state disabled}}
      {frAflb.butView - - - - {pack -side right -anchor nw -pady 5} {-t "View the file" -com  t::viewfile -tooltip "Opens a stand-alone viewer of the file\nthe listbox' data are taken from."}}
      {frAflb.lab - - - - {pack -side right -anchor nw -pady 9} {-t " "}}
      {frAflb.laB - - - - {pack -side left -anchor nw} {-t "Listbox of file content:  \n\nSee also:\nGeneral/Misc. tab"}}
      {frAflb.flb - - - - {pack -side left -fill x -expand 1} {-lvar ::t::lv1 -lbxsel Cont -w 50 -tooltip "The 'flb' listbox contains:\n 1)  four literal lines\n  2) data from 'test2_fco.dat' file" -values {@@-div1 " \[" -div2 "\] " test2_fco.dat@@   INFO: @@-pos 22 -ret 1 -list {{Content of test2_fco.dat} {another item} trunk DOC} test2_fco.dat@@}}}
      {frAflb.sbv frAflb.flb L - - {pack -side left}}
      {frAflb.sbh frAflb.flb T - - {pack -side left}}
    } .win.fNB.nb2.f2 {
      {lab - - - - {pack -expand 1 -fill both} {-t "Some text of 2nd View" \
      -font "-weight bold -size 11"}}
    }

    # text widget's name is uppercased, so we can use the Text method
    set wtex [pave Text]
    # bindings and contents for text widget
    bind $wtex <ButtonRelease> [list t::textPos $wtex]
    bind $wtex <KeyRelease> [list t::textPos $wtex]
    $wtex replace 1.0 end $::t::filetxt
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
    ttk::notebook .win.fNB.nb3
    .win.fNB.nb3 add [ttk::frame .win.fNB.nb3.f1] -text "Editor options"
    pave window .win.fNB.nb3.f1 $lst3

    # 4th and other frames mean even less efforts applied
    foreach {nn inf} {4 Files 5 Tools 6 "Key mappings" 7 Misc} {
      ttk::notebook .win.fNB.nb$nn
      pack [ttk::label .win.fNB.nb$nn.labB -text "$inf here..." \
        -foreground blue -font "-weight bold -size 12"] -expand 1
    }

    # the general layout of window (main frames and buttons):
    pave window .win {
      {fral - - 8 1   {-st nes -rw 1}}
      {.butGen - - 1 1 {-st we} {-t "General" -com "t::chanTab nb"}}
      {.but2 fral.butGen T 1 1 {-st we} {-t "View" -com "t::chanTab nb2"}}
      {.but3 fral.but2 T 1 1 {-st we} {-t "Editor" -com "t::chanTab nb3"}}
      {.but4 fral.but3 T 1 1 {-st we} {-t "Files" -com "t::chanTab nb4"}}
      {.but5 fral.but4 T 1 1 {-st we} {-t "Tools" -com "t::chanTab nb5"}}
      {.but6 fral.but5 T 1 1 {-st we} {-t "Key maps" -com "t::chanTab nb6"}}
      {.but7 fral.but6 T 1 1 {-st we} {-t "Misc" -com "t::chanTab nb7"}}
      {.fra  fral.but7 T 1 1 {-st we -rw 10} {-h 30.m}}
      {buth fral T 1 1 {-st e} {-t "Help"    -com t::helpProc}}
      {frau buth L 1 1 {-st nswe -cw 10} {-w 60.m}}
      {butApply frau L 1 1 {-st e} {-t "Apply"  -com t::applyProc}}
      {butCancel butApply L 1 1 {-st e} {-t "Cancel" -com t::cancelProc}}
      {butOK butCancel L 1 1 {-st e} {-t "OK"     -com t::okProc}}
      {fNB fral L 8 9 {-st nsew}}
    }

    # filling the menu
    after idle [list ::t::fillMenu]
    # Open the window at last
    set ::t::curTab ""
    chanTab nb
    set res [pave showModal .win -geometry +300+80 -decor 1 -onclose t::exitProc]

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
    lvar= \"$t::lvar\"
    lv1 = \"$t::lv1\"
    Tbl1 selected = [lindex $::t::tbllist {*}[[pave Tbl1] curselection]]
    "
    destroy .win
    apave::APaveInput destroy
    return $res
  }

  #########################################################################

  # we need the procedures for Help, Apply, Cancel, Ok etc. actions

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
      set t::ans2 [lindex [pdlg yesno warn "CANCEL" \
        "\nCancel all changes?\n" NO -ch "Don't show again"] 0]
      if {$t::ans2==1 || $t::ans2==11} {
        pave res .win 0
      }
    }
  }

  # imitating save & exit function
  proc okProc {} {
    pdlg ok info "SAVE" "Saving changes...\nCurtain." -weight bold -size 16
    pave res .win 1
  }

  # imitating the toolbar functions
  proc toolButt {num} {
    if {$num == 4} {
      [pave Menu] entryconfigure 2 -font {-slant roman -size 10}
      [pave BuT_Img3] configure -state normal
      [pave BuT_Img4] configure -state disabled
    } elseif {$num == 3} {
      pave themingRestore
      [pave Menu] entryconfigure 2 -font {-slant italic -size 10}
      [pave BuT_Img3] configure -state disabled
      [pave BuT_Img4] configure -state normal
    } elseif {$num == 2} {
      [pave Pro] stop
      .win.fNB.nb tab 3 -state disabled
    } elseif {$num == 1} {
      [pave Pro] start
      .win.fNB.nb tab 3 -state normal
    }
    [pave Menu] entryconfigure 2 -state [[pave BuT_Img3] cget -state]
    [pave File] entryconfigure 2 -state [[pave BuT_Img4] cget -state]
    [pave File] entryconfigure 3 -state [[pave BuT_Img4] cget -state]
    if {$num == 4} {
      pave themingWindow . \
        white #364c64 white #383e41 white #4a6984 grey #364c64 #02ffff #00a0f0
    }
  }

  # ask about exiting
  proc exitProc {resExit} {
    upvar $resExit res
    if {[pdlg yesno ques "EXIT" "\nClose the test?\n" NO]==1} {
      set res 0
    }
  }

  # changing the current tab: we need to save the old tab's selection
  # in order to restore the selection at the tab's return.
  proc chanTab {tab} {
    if {$tab != $::t::curTab} {
      if {$::t::curTab !=""} {
        set arrayTab($::t::curTab) [.win.fNB.$::t::curTab select]
        pack forget .win.fNB.$::t::curTab
      }
      set ::t::curTab $tab
      pack .win.fNB.$::t::curTab -expand true -fill both
      catch {
        .win.fNB.$::t::curTab select $arrayTab($::t::curTab)
      }
    }
  }

  # displaying the cursor position and the current line's contents
  proc textPos {txt} {
    catch {
      lassign [split [$txt index insert] .] r c
      [pave Labstat1] configure -text $r
      [pave Labstat2] configure -text [incr c]
      [pave Labstat3] configure -text [$txt get \
        [$txt index "insert linestart"] [$txt index "insert lineend"]]
    }
  }

  # filling the menu
  proc fillMenu {} {
    set m .win.menu.file
    $m add command -label "Open..." -command {::t::msg info "this is just a demo:\nno action has been defined for the \"Open...\" entry"}
    $m add command -label "New" -command {::t::msg info "this is just a demo:\nno action has been defined for the \"New\" entry"}
    $m add command -label "Save" -command {::t::msg info "this is just a demo:\nno action has been defined for the \"Save\" entry"}
    $m add command -label "Save As..." -command {::t::msg info "this is just a demo:\nno action has been defined for the \"Save As...\" entry"}
    $m add separator
    $m add command -label "Quit" -command {::t::pave res .win 0}
    set m .win.menu.edit
    $m add command -label "Cut" -command {::t::msg ques "this is just a demo: no action"}
    $m add command -label "Copy" -command {::t::msg warn "this is just a demo: no action"}
    $m add command -label "Paste" -command {::t::msg err "this is just a demo: no action"}
    set m .win.menu.help
    $m add command -label "User Guide" -command {::t::msg info "this is just a demo: no action"}
  }

proc tracer {varname args} {
  set ::t::sc2 [expr round($::t::sc)]
}

proc viewfile {} {
  set res [pdlg vieweditFile test2_fco.dat "" -h {1 20} -w {1 74} -rotext ::temp]
#  set res [pdlg vieweditFile test2_fco.dat "" -w 74 -h 20 -ro 0 -rotext ::temp -weight bold -size 14]
  puts "\n------------\nResult: $res.\nContent:\n$::temp\n------------\n"
  unset ::temp
}

proc msg {icon message} {
  pdlg ok $icon [string toupper $icon] \n$message\n
}

} ;# end of namespace

###########################################################################
# Run the tests

# In the "real life", the parent window is visible.
# Here we hide it to run tests with "wish" being invisible.
if {$::tcl_platform(platform) == "windows"} {
  wm attributes . -alpha 0.0
} else {
  wm attributes . -type splash
  wm geometry . 0x0
}
ttk::style theme use clam

puts "result of test2 = [t::test2]"

exit
