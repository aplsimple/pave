#! /usr/bin/env tclsh

# testing bartabs

#----------------------------------

package require Tk

lappend auto_path [file dirname [info script]] ../baltip
package require bartabs

#----------------------------------

image create photo markimg -data {iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0
U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAMFSURBVHjaYvz//z8DJQAgAINxcAQgCANA
8MgQlRkefrUDLZM6LBQSAd3XxlxOZofYNtQTWhMWOqYVxHjVsdWY0gj/x+Iw7NqP/KByfwKIiSTr
QI79/TtBXVlqV6S1hZUAK98/gAAi2gCgV0X/MTHMdrfQm1/r6Shz8drzfw/uvEoECCCW/wz/FYHB
8A2o5iUOnQz//vwz4xbjnJ/soqUVoKHM0LH7PMOx0w8yGbmZNgEEEIuQCO/VX7//3fz8+I8PGwPD
UxS9//6z/vj7J1VOTbCnwseY00ZcgKF853mGXQcf1DOxs8xiYPzHABBATHzM3J99HBQNuAXZVv7+
808IrJMRGE5//2v85WBY5uaoNHVqmAenlbgkQ+Oeawy79j7vZ/vP0sTABIk9gABienbn+0wJBjGG
7EAra0YuhnX//jEw/vn9z5VXnGVXarBBSIOrO4M4Dw9D78FLDNu2v1zF/pu5nAEp5AACAEEAvv8D
BjAZ5u70+2RxSUoEBw3+H8fX4mUiKg1hdlc6FEoiMwD4/vMAn8nQAK6t6bgA+v1dAAf89/wE+gD9
BvkA/wf8AAIAQQC+/wMQMCHw7e73HRUcCDNXMDwBCBn3DlM2LgUqDyMA7vzpALHU0wCxquzRAfIB
WQUFAuwD/QQABf0GAAb7CQAG+QoAAgBBAL7/AxAvIv/99AX78gHvWy8nFwEwFiQAA/8DAO/96gC/
3dYArqXx4P/tAU0GBwHgBfwGAAb8CAAI+QwACPYPAAn0EAACiFlIQ5uB9Q/H4y+f/1nxq35V4mFn
Yfj0/xXD6Sf3GLYu/f7m91OWACaO31f+M/+DeJoRGPEgzPQPjAECiInjFzsD5z+2n4zP+LaePv2e
4TnjHYaLr+4z7Fz668uv21wxzMwMp/ElMIAAYmL+y84Awhz/2Be9PsP98MTt5wxHVzH/+n5ZIBuo
eSehFAoQQMwSakbAKGVmYGJk/M70jUPszW0eix/XeesYmP9M+8/2h+Ef82+G/yzADAT2AiOGAQAB
xEhpdgYIMABQrSEzlY7wIwAAAABJRU5ErkJggg==}

#----------------------------------

proc ::TestDel {b t l} {
  return [bartabs::messageBox yesnocancel "Closing \"$l\"" "\nReally close \"$l\"?" \
    -icon question -detail "\nDetails: bar=$b tab=$t label=$l"]
  return [expr {$res eq "yes" ? 1 : ($res eq "no" ? 2 : 0)}]
}

#----------------------------------

proc ::TestAdd {BID} {
  set newTID [::bts $BID insertTab $::noname]
  if {$newTID==""} {
    set newTID [::bts $BID tabID $::noname]
    if {$newTID==""} {
      tk_messageBox -title "Error" -message "  \nThe tab not created." \
        -icon error -type ok
      return
    }
  }
  ::bts $newTID show
}

#----------------------------------

proc ::TestSwitch {BID TID optname} {
  set val [::bts $BID cget $optname]
  if {[expr {$val eq "" || !$val}]} {set val yes} {set val no}
  ::bts $BID configure $optname $val
  if {$optname in {-static -hidearrows -expand -bd}} {::bts $BID update}
  set bwidth [::bts $BID cget -width]
  set twidth [expr {[::bts isTab $TID]?[::bts $TID cget -width]:0}]
  tk_messageBox -title "Info" -message "  \nThe \"$optname\" option is \"$val\"." \
    -detail "\n$BID's width is $bwidth.\n$TID's width is $twidth." \
    -icon info -type ok
}

#----------------------------------

proc ::TestComm {oper args} {
  puts "$oper: $args"
  return yes
}

#----------------------------------

proc ::TestViewSel {BID} {
  set sellist ""
  set fewsel [::bts $BID listFlag "s"] 
  set tcurr [::bts $BID cget -tabcurrent]
  foreach TID $fewsel {
    set text [::bts $TID cget -text]
    append sellist "TID: $TID, label: $text\n"
  }
  if {$tcurr eq ""} {
    set text ""
  } else {
    set text [::bts $tcurr cget -text]
  }
  tk_messageBox -title "Info" -message "Selected tabs:\n\n$sellist" \
    -detail "Current tab: TID: $tcurr, label: $text\n\nClick on a tab while pressing Ctrl\nto select few tabs." -icon info -type ok
}

#----------------------------------

proc ::TestDsbl {BID TID menuitem} {
  set static [::bts $BID cget -static]
  return [expr {$static && $menuitem eq "Append $::noname"}]
}

#----------------------------------

proc ::TestPopupTip {wmenu idx TID} {
  set text "Some tips about\n\"[::bts $TID cget -text]\""
  catch {::baltip tip $wmenu $text -index $idx}
}

#----------------------------------

proc ::FillBarTabs {} {

  set ::noname "<No name>"
  set ::frm .frame
  set ::l0 $::frm.l0
  set ::l1 $::frm.l1
  set ::l2 $::frm.l2
  set ::w0 $::frm.f0
  set ::w1 $::frm.f1
  set ::w2 $::frm.f2
  set ::w3 $::frm.f3
  set ::l3 $::w3.l3
  set ::w4 $::frm.f4
  set ::w5 $::w4.f5
  toplevel $::frm
  wm minsize $::frm 200 350
  wm geometry $::frm +500+200
  wm protocol $::frm WM_DELETE_WINDOW {catch {::bts destroy}; exit}
  ttk::label $::l0 -text "Absolutely static:"
  ttk::label $::l1 -text [string repeat "0123456789" 6]
  ttk::label $::l2 -text [string repeat "0123456789" 12]
  ttk::frame $::w0
  ttk::frame $::w1
  ttk::frame $::w2
  ttk::frame $::w3
  ttk::label $::l3 -text [string repeat "0123456789" 4]
  ttk::frame $::w4
  ttk::frame $::w5
  pack $::l0 -anchor w -pady 10
  pack $::w0 -side top -anchor nw -expand 1
  pack $::l1 -anchor sw -pady 10
  pack $::w1 -side top -anchor nw -expand 1
  pack $::l2 -anchor w -pady 10
  pack $::w2 -side top -anchor nw -expand 1 -fill x
  pack $::l3 -pady 10
  pack $::w3 -side left -anchor n
  pack $::w5 -expand 1 -fill x -pady 10
  pack $::w4 -side left -after $::w3 -expand 1 -fill x -anchor ne

  set barOpts0 [list -wbar $::w0 -wbase $::frm -wproc "winfo width $::l1" \
    -popuptip ::TestPopupTip \
    -static yes -hidearrows yes -padx 6 -pady 6 -csel "::TestComm sel %b %t {%l}"]

  set barOpts1 [list -tleft 1 -tright 5 -wbar $::w1 -fgsel "" \
    -wbase $::frm -wproc "winfo width $::l1" -popuptip ::TestPopupTip \
    -hidearrows yes -relief sunken  -static 1 -tiplen -1 \
    -csel {::TestComm sel %b %t {%l}} \
    -cdel {::TestDel %b %t {%l}} \
    -menu [list sep "com {Append $::noname} {::TestAdd %b} {} ::TestDsbl" sep \
    "com {Switch -static option} {::TestSwitch %b %t -static}" \
    "com {Switch -scrollsel option} {::TestSwitch %b %t -scrollsel}" \
    "com {Switch -hidearrows option} {::TestSwitch %b %t -hidearrows}"] ]

  set barOpts2 [list -wbar $::w2 -wbase $::l2 -pady 3 \
    -lablen 11 -expand 0 -imagemark markimg -tiplen 15 -dotip yes \
    -tleft 3 -fgsel black -bgsel #999999 -popuptip ::TestPopupTip \
    -cmov {::TestComm mov %b %t {%l}} \
    -csel {::TestComm sel %b %t {%l}} \
    -cdel {::TestDel %b %t {%l}} \
    -font "-family Helvetica -size 12" -scrollsel 1 \
    -menu [list sep "com {Append $::noname} {::TestAdd %b}" \
    "com {View selected} {::TestViewSel %b}" \
    sep \
    "com {Switch -expand option} {::TestSwitch %b %t -expand}" ]]
  
  set barOpts3 [list -wbar $::w5 -wbase $::frm -tleft 7 -bd 0 -popuptip ::TestPopupTip \
    -wproc "expr {\[winfo width $::frm\]-\[winfo width $::l3\]-80}" \
    -menu [list sep "com {Switch -bd option} {::TestSwitch %b %t -bd}"]]
  
  lappend barOpts1 -tab "#0 tab item" ;# to test for duplicates
  lappend barOpts2 -tab "#0 tab item" -tab "Item 1 \" \{ ?"
  for {set n 0} {$n<10} {incr n} {
    set tab "#$n tab item[string repeat ~ [expr $n/2]]"
    if {$n<4} {lappend barOpts0 -tab $tab}
    lappend barOpts1 -tab $tab
    lappend barOpts2 -tab $tab
    lappend barOpts3 -tab $tab
  }
  for {set n 0} {$n<=40} {incr n} {    ;# set 100 to make it be idiotic
    set tab "#$n tab item[string repeat ~ [expr $n/2]]"
    lappend barOpts2 -tab $tab
    lappend barOpts3 -tab $tab
  }

  bartabs::Bars create ::bts
  ::bts create ::bar0 $barOpts0
  ::bts create ::bar1 $barOpts1
  set ::bar2 [::bts create $barOpts2]
  set ::bar3 [::bts create $barOpts3]
}

#----------------------------------

if {$::tcl_platform(platform) == "windows"} {
  wm attributes . -alpha 0.0
} else {
  wm withdraw .
}
try {ttk::style theme use clam}

::FillBarTabs

catch {
  source [file join ../transpops/transpops.tcl]
  #set ::transpops::my::perchars 1.0 ;# for popups to be 12 times longer
  ::transpops::run .bak/transpops.txt {<Control-q> <Alt-q>} .frame
}

if {1} {
  ####### some mimicring actions with bars & tabs:
  toplevel .mimi
  label .mimi.l -text "\n Please wait 7 seconds \n while seeing this test. \n" -fg black -bg #f4eca1 -font {-weight bold}
  lassign [split [winfo geometry $::frm] x+] w h x y
  lassign [split [winfo geometry .mimi] x+] ::w2 h2
  wm geometry .mimi +$x+[expr {$y+$h+10}]
  pack .mimi.l
  update
  after 3000
  after 1000 {::bts tab4 show ; ::bts tab15 show}
  after 2000 {::bts markTab tab11 tab12 tab13 tab14 tab15 tab17 tab18}
  after 2500 {::bar0 disableTab tab19 tab3}  ;# any bar can use disable/mark
  after 3000 {::bts unmarkTab tab11 tab17 tab18}
  after 3500 {::bts enableTab tab3}
  after 4000 {::bar0 insertTab "-0.5 item" 0}
  after 4000 {::bar1 insertTab "Button 0.5" 1}
  after 4000 [list ::bts $::bar2 insertTab "Button 0.5" 1]
  after 4500 {::bts tab11 configure -text "==12th tab==" ; ::bts tab11 show}
  after 5000 {::bts tab18 close}
  after 5050 {if {[winfo exists .mimi]} {destroy .mimi}}
  after 6000 {::bts tab11 drawAll ;
    ::bar1 create ::tab8 "#8 tab item~~~~"
    ::bar1 create ::tab9 "#9 tab item~~~~"
    ::tab8 configure -text "#8 TAB ITEM"
    ::tab9 configure -text "#9 TAB ITEM"
    ::bar1 create ::tab82 "#8 TAB ITEM"  ;# the same ::tab8
    ::bar1 create ::tab92 "#9 TAB ITEM"
    ::tab92 disableTab tab2
    ::bts bar1 markTab tab19  ;# Bars don't forbid using (useless though) TID/BID
  }
  after 6500 {
    ::bar1 configure -tleft 7 -tright end
    ::bar1 clear
    ::bar1 draw
  #after 7000 {::bts destroy}  ;# testing destructor
  }

}  
