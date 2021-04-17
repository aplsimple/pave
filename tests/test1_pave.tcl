#! /usr/bin/env tclsh

###########################################################################
#
# Nearly the same as test0.tcl.
# Added "Stay on top", "Replace by blank" and some ornaments.
#
###########################################################################

package require Tk

set ::testdirname [file normalize [file dirname [info script]]]
catch {cd $::testdirname}
lappend auto_path "$::testdirname/.."
package require apave

apave::initWM
set win .win
set c1 [set c2 [set c3 [set c4 [set c5 0]]]]
set values1 [list exac "gl*" {\s+reg[[:alpha:]]*$}]
set values2 [list "Exact matching string" "Global subject" "Boss Regularity"]
set v1 [set v2 1]
set en1 [set en2 ""]
# get localized labels & tips
set mttl [msgcat::mc "Find and Replace (+ Stay on top)"]
set mfind [msgcat::mc "Find: "]
set mrepl [msgcat::mc "Replace: "]
set mmatch [msgcat::mc "Match: "]
set mexact [msgcat::mc "Exact"]
set mword [msgcat::mc "Match whole word only"]
set mcase [msgcat::mc "Match case"]
set mwrap [msgcat::mc "Wrap around"]
set mblnk [msgcat::mc "Replace by blank"]
set mdir [msgcat::mc "Direction:"]
set mdown [msgcat::mc "Down"]
set mup [msgcat::mc "Up"]
set montop [msgcat::mc "Stay on top"]
set mfind1 [msgcat::mc "Find"]
set mrepl1 [msgcat::mc "Replace"]
set mfind2 [msgcat::mc "All in Text"]
set mfind3 [msgcat::mc "All in Session"]
set mtip1 [msgcat::mc "Allows to use *, ?, \[ and \]\nin \"find\" string."]
set mtip2 [msgcat::mc "Allows to use the regular expressions\nin \"find\" string."]
set mtip3 [msgcat::mc "Allows replacements by the empty string,\nin fact, to erase the found ones."]
set mtip4 [msgcat::mc "Keeps the dialogue above other windows."]
# create apave object and pave its window
apave::APave create pave
pave makeWindow $win.fra $mttl
pave paveWindow $win.fra {
  {labB1 - - 1 1    {-st e}  {-t {$::mfind}}}
  {cbx1 labB1 L 1 9 {-st wes} {-tvar ::en1 -values {$::values1}}}
  {labB2 labB1 T 1 1 {-st e}  {-t {$::mrepl}}}
  {cbx2 labB2 L 1 9 {-st wes} {-tvar ::en2 -values {$::values2}}}
  {labBm labB2 T 1 1 {-st e}  {-t {$::mmatch}}}
  {radA labBm L 1 1 {-st ws}  {-t {$::mexact} -var ::v1 -value 1}}
  {radB radA L 1 1 {-st ws}  {-t "Glob" -var ::v1 -value 2 -tooltip {$::mtip1}}}
  {radC radB L 1 1 {-st es}  {-t "RE  " -var ::v1 -value 3 -tooltip {$::mtip2}}}
  {h_1 radC L 1 2  {-cw 1}}
  {h_2 labBm T 1 9  {-st es -rw 1}}
  {seh  h_2 T 1 9  {-st ews}}
  {chb1 seh  T 1 2 {-st w} {-t {$::mword} -var ::c1}}
  {chb2 chb1 T 1 2 {-st w} {-t {$::mcase}  -var ::c2}}
  {chb3 chb2 T 1 2 {-st w} {-t {$::mwrap} -var ::c3}}
  {chb4 chb3 T 1 2 {-st w} {-t {$::mblnk} -var ::c4 -tooltip {$::mtip3}}}
  {sev1 chb1 L 5 1 }
  {labB3 sev1 L 1 2 {-st w} {-t {$::mdir}}}
  {rad1 labB3 T 1 1 {-st we} {-t {$::mdown} -var ::v2 -value 1}}
  {rad2 rad1 L 1 1 {-st we} {-t {$::mup} -var ::v2 -value 2}}
  {h_3 rad1}
  {chb5 h_3 T 1 2 {-st w} {-t {$::montop} -var ::c5 -tooltip {$::mtip4}}}
  {sev2 cbx1 L 10 1 }
  {but1 sev2 L 1 1 {-st we} {-t {$::mfind1} -com "::pave res $win 1" -style TButtonWestBold}}
  {but2 but1 T 1 1 {-st we} {-t {$::mfind2} -com "::pave res $win 2" -style TButtonWest}}
  {but3 but2 T 1 1 {-st we} {-t {$::mfind3} -com "::pave res $win 3" -style TButtonWest}}
  {h_4 but3 T 2 1 {-pady 6}}
  {but4 h_4 T 1 1 {-st we} {-t {$::mrepl1}  -com "::pave res $win 4" -style TButtonWestBold}}
  {but5 but4 T 1 1 {-st nwe} {-t {$::mfind2} -com "::pave res $win 5" -style TButtonWest}}
  {but6 but5 T 1 1 {-st nwe} {-t {$::mfind3} -com "::pave res $win 6" -style TButtonWest}}
  {but0 but6 T 1 1 {-st swe} {-t "Close" -com "::pave res $win 0" -style TButtonWestBold}}
}
bind $win.fra.cbx1 <Return> {$win.fra.but1 invoke}  ;# the Enter key is
bind $win.fra.cbx2 <Return> {$win.fra.but4 invoke}  ;# hot in comboboxes
set foc $win.fra.cbx1
set geo +200+200   ;# these geometry options
set minsize ""     ;# are possibly stored in some INI file
set res 1
while {1} {
  if {$minsize eq ""} {      ;# save default min.sizes
    after idle [list after 10 {
      set ::minsize "-minsize {[winfo width $::win] [winfo height $::win]}"
    }]
  }
  set res [pave showModal $win -focus $foc -geometry $geo {*}$minsize -resizable {1 0}]
  if {!$res} break
  if {$en1 eq "" || ($res>3 && $en2 eq "" && !$c4)} bell
  wm attribute $win -topmost $c5
  set geo [wm geometry $win] ;# save the new geometry of the dialogue
  set foc $win.fra.cbx1
  foreach i {2 1} {          ;# check the comboboxes for emptiness
    if {[set en$i] eq ""} {  ;# to focus in the next loop
      set foc $win.fra.cbx$i
    } else {                 ;# last ones to be first
      if {[set f [lsearch -exact [set values$i] [set en$i]]]>-1} {
        set values$i [lreplace [set values$i] $f $f]
      }
      set values$i [linsert [set values$i] 0 [set en$i]]
      $win.fra.cbx$i configure -values [set values$i]
    }
  }
  # here might be some procedures to process the input data, e.g. showing:
  if {$::c2} {set c ""} {set c "-nocase "}
  switch $::v1 {
    2 {
      set r [string match {*}$c $en1 $en2]
    }
    3 {
      if {[catch {set r [regexp {*}$c $en1 $en2]}]} {set r 0}
    }
    default {
      set r [string match {*}$c "*$en1*" $en2]
    }
  }
  set fnd "Applying \"Find\" to \"Replace\": [if $r {set - yes} {set - no}]"
  puts "
      $mfind $en1
      $mrepl $en2
      $fnd

      E/G/R=$v1
      $mword=$c1
      $mcase=$c2
      $mwrap=$c3
      $mblnk=$c4
      $montop=$c5
      $mdir $v2
      Mode=$res
      _________________________________"
}
pave destroy
destroy $win
exit
