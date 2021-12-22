#! /usr/bin/env tclsh
###########################################################
# Name:    test.tcl
# Author:  Alex Plotnikov  (aplsimple@gmail.com)
# Date:    12/06/2021
# Brief:   Handles a test for baltip package.
# License: MIT.
###########################################################

# ____________________________________ auto_path ______________________________________ #

cd [file dirname [info script]]
lappend auto_path .
package require baltip

# _____________________________________ Callbacks _____________________________________ #

proc ::butComm {} {
#  ::baltip::clear .
  ::baltip hide .b
  if {[incr ::ttt]%2} {
    puts "the button's tip disabled"; bell
    ::baltip::tip .lb "Listbox tip:\nfor a lisbox as a whole.\n%%i used." -reset yes
    ::baltip::tip .tre "Treeview tip:\nfor a treeview as a whole.\n%%i, %%c used." -reset yes
    ::baltip tip .b "" -image TEST_TCL_IMAGE1 -compound right
    ::baltip update .l "        Danger!\n  Don't trespass!\n\n\"Eternal\" warning." \
      -per10 0 -fg white -bg red -font {-weight bold} -padx 20 -pady 15 -global 0
  } else {
    puts "the button's tip enabled"; bell
    ::baltip::tip .lb {::LbxTip %i} -reset yes
    ::baltip::tip .tre {::TreTip %i %c} -reset yes
    if $::ttt>1 {
      set img TEST_TCL_IMAGE2
      set msg {smaller and smaller...}
      set cmpd right
    } else {
      set img TEST_TCL_IMAGE1
      set msg great!
      set cmpd left
    }
    ::baltip config -global yes -fg black -bg #FBFB95 -padx 4 -pady 3 \
      -font "-size [expr {max(3,11-$::ttt/2)}] -weight normal"
    ::baltip tip .b "Hi again, world! \
      \nI feel $msg" -under 0 -force yes -image $img -compound $cmpd
    ::baltip update .l "It's okay. Come on!" \
      {*}[::baltip cget -fg -bg -font -padx -pady]  -per10 1500
  }
  if {$::ttt>7} {set ::ttt -2}
}
#_______________________

proc ::chbComm {}  {
    puts "all tips [if $::on {set _ enabled} {set _ disabled}]"
    ::baltip config -global yes -on $::on -fg $::fg -bg $::bg
    ::baltip update .cb "After clicking:\nnew tip & options" \
      -fg maroon -padding 2 -padx 15 -pady 15 -global 0
    if {$::on} {::baltip repaint .cb}
}
#_______________________

proc ::LbxTip {idx} {
  set item [lindex $::lbxlist $idx]
  return "Tip for \"$item\"\nindex=$idx"
}

#_______________________

proc ::TreTip {id c} {
  set item [.tre item $id -text]
  return "Tip for \"$item\"\nID=$id, column=$c"
}

proc ::TreTipId {id} {
  set item [.tre item $id -text]
  return "Tip for \"$item\"\nID=$id"
}

proc ::TreTipC {c} {
  return "Tip for column=$c"
}

proc ::Status {tip args} {
  .status configure -text [string map [list \n { }] $tip] {*}$args
  return {}  ;# means the proc executed and no tip needed
}

proc ::SomeProc {tip} {
  lassign [split $tip] obj ID column
  if {[info exists ::OBJsaved]} {
    puts "$::OBJsaved object ID=[set ::IDsaved] is left... unhighlighted..."
    unset ::OBJsaved
  }
  if {$obj ne {}} {
    set ::OBJsaved $obj
    set ::IDsaved $ID
    puts "Now processing $obj object with ID=$ID column=$column"
  }
  return {}  ;# means the proc executed and no tip needed
}

# _____________________________________ Images _____________________________________ #

set tclimg {iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAABlBMVEUAAAC1CgZ1fsiLAAAAAnRS
TlMA/1uRIrUAAADmSURBVFjD3djLEsIgDIXhc97/pd24aFXIhR9xzJK23zApJaHSP4ZNOYYYAPIz
GGXN8TUQpA35QyBI3fEwEKQC2YTjOCAmA5lxbASyGQhybAY64bjhiEmzmOXzOtz9KIbD1f2vkep9
TnNr3OUEyzMNBas866jtqOR4vyPKUYHBnBy06OjXHFGOKEdzp9hLTYtI0Vnu8GInDUEd59w500eP
ihFwOjh64HndRs6fBnln34QGpWV0UB/PpwdpFQoSdLlyu+ntiSjRWSh8Yd+GUn1KAsr1KXlIq1Cy
nM9bjXuFJSBBEPGL7AEx9we9fjFHxQAAAABJRU5ErkJggg==}

set warnimg {iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAAkFBMVEUAAACTAACyAACMAACPAAB2
AACZAACLAAB1AAB2AAB3AAB3AAB3AAB1AABxAABwAABwAABwAABwAABwAABwAADu7u7WAACfAADs
7Ozw8PDq6enjq6vmpqZaWlrbOjrCAADbLS3t6url5eXh4eHhrq7mk5NoaGhNTU1DQ0PZQUFAQEDc
MzMxMTG8AAC4AAC7FBTG2r10AAAAFXRSTlMA+/76+bb+8uvd1cvAl2NYTUM6MRjtzZKZAAAAnUlE
QVQY01WKRRLDMBAEJTPzxmuZmZ3//y5KHHD6MtVdQ04iWY7IFTmO5auHYnUXw0uwhK4TrJ8H4tw0
sxh8gymk25YK5sd9qWDLwgrJfwfjSNk4svQwTvf4geU54xfvFfQ9QxwGxGzXn+7StUZsW8R6pS4P
apkB4DQhQFaqhDi0ggQgz4FPRR2ilX2SJMDh05caUW5/KMSm8QVqPwAheA8OJkYEHwAAAABJRU5E
rkJggg==}

image create photo TEST_TCL_IMAGE1 -data $tclimg

image create photo TEST_TCL_IMAGE2 -data $warnimg

# _____________________________________ Widgets _____________________________________ #

button .b -text Hello -command ::butComm

set geo +999999+85  ;# 999999 to get it the most right
set alpha 0.5
lassign [::baltip cget -fg -bg] - ::fg - ::bg
set ::fg0 $::fg
set ::bg0 $::bg
set ::fg1 white
set ::bg1 black
button .b2 -text "Balloon at $geo" -command {::baltip tip "" \
  "It's a stand-alone balloon\nto view in black & white \
  \nbold font and $alpha opacity." -alpha $alpha -fg white -bg black \
  -font {-weight bold -size 11} -per10 1400 -pause 1500 -fade 1500 \
  -geometry $geo -bell yes -on yes -padding 2 -relief raised -image TEST_TCL_IMAGE1}

label .l -text "Click me (tearoff popup)"

text .t -width 24 -height 4
.t insert 1.0 "1st line: tag1\n2nd line: tag2\n3rd line: no tags"
.t tag configure UnderLine1 -font "-underline 1"
.t tag configure UnderLine2 -font "-weight bold"
.t tag add UnderLine1 1.10 1.15
.t tag add UnderLine2 2.10 2.15

set ::lbxlist {
  Listbox:
  {Listbox: 2nd item}
  {Listbox: qwerty}
  {Listbox: next to last item}
  {Listbox: last item}
}

listbox .lb -listvariable ::lbxlist -height 3

ttk::treeview .tre -columns {COL2} -displaycolumns {COL2} -height 3
.tre column #0 -width 20
.tre column COL2 -width 10 -anchor e
.tre heading #0 -text {Treeview}
.tre heading COL2 -text {index}
foreach idx {0 1 2 3 4 5} {
  .tre insert {} end -text "Item #[expr $idx+1]" -value $idx
}

set ::on 1
checkbutton .cb -text "Tips on" -variable ::on -command ::chbComm

label .status -relief sunken -anchor w

# _____________________________________ Pack _____________________________________ #

pack .b .l .b2
pack .t -expand 1 -fill x
pack .lb -expand 1 -fill x
pack .tre -expand 1 -fill both
pack .cb
pack .status -fill x
update
set ww [winfo width .]
set wh [winfo height .]
wm minsize . [incr ww 10] [incr wh 30]

# _____________________________________ Menu _____________________________________ #

set m [menu .popupMenu]
$m add command -label \
  "Global settings: -fg $::fg1 -bg $::bg1 -relief raised -alpha 0.8" -command " \
  ::baltip config -fg $::fg1 -bg $::bg1 -global yes -relief raised -alpha 0.8; \
  ::Status {Set new colors of all tips} -font {[font actual TkTooltipFont] -weight bold}"
$m add command -label \
  "Global settings: -fg $::fg0 -bg $::bg0 -relief solid -alpha 1.0" -command " \
  ::baltip config -fg $::fg0 -bg $::bg0 -global yes -relief solid -alpha 1.0; \
  ::Status {Restored colors of all tips} -font TkTooltipFont"
bind .l <Button-3> {tk_popup .popupMenu %X %Y}

menu .menu -tearoff 0

set m .menu.file
menu $m -tearoff 0
.menu add cascade -label "File" -menu $m -underline 0
$m add command -label "Open..." -command {puts "\"Open...\" entry"}
$m add command -label "New" -command {puts "\"New\" entry"}
$m add command -label "Save" -command {puts "\"Save\" entry"}
$m add separator
$m add command -label "Balloon" -command {after idle {.b2 invoke}} -accelerator F5
$m add separator
$m add command -label "Exit" -command {exit}
set m .menu.help
menu $m -tearoff 0
.menu add cascade -label "Help" -menu $m -underline 0
$m add command -label "About" -command { \
  puts "\nWelcome to baltip v[package require baltip] at \
    \n  https://chiselapp.com/user/aplsimple \
    \n  https://github.com/aplsimple\n"}

. configure -menu .menu
bind . <F5> {.b2 invoke}

# _____________________________________ Tips _____________________________________ #

::baltip::configure -per10 1200 -fade 300 -font {-size 11}
::baltip::tip .b "Hello, world!\nIt's me o Lord!" -under 0 -per10 3000 \
  -fg #a40000 -bg #bafaba -font {-weight bold -size 12} \
  -image TEST_TCL_IMAGE1 -compound left
::baltip::tip .l "Calls a popup tearoff menu.\nThis tip is switched by the button\nto an alert/message."
::baltip::tip .b2 "Displays a message at top right corner, having\
  \ncoordinates set with \"-geometry $geo\" option."
::baltip::tip .status "Status bar for tips." -command {::Status {%t}}
::baltip::tip .popupMenu "Sets new colors of all tips" -index 1
::baltip::tip .popupMenu "Restores colors of all tips" -index 2
::baltip::tip .menu "File actions" -index 0 -command {::Status {%t}}
::baltip::tip .menu "Help actions" -index 1 -command {::Status {%t}}
::baltip::tip .menu.file "Opens a file\n(stub)" -index 0 -command {::Status {%t}}
::baltip::tip .menu.file "Creates a file\n(stub)" -index 1 -command {::Status {%t}}
::baltip::tip .menu.file "Saves a file\n(stub)" -index 2 -command {::Status {%t}}
::baltip::tip .menu.file "Shows a balloon\nat right top corner" -index 4 -command {::Status {%t}}
::baltip::tip .menu.file "Closes the test" -index 6 -command {::Status {%t}}
::baltip::tip .menu.help "Info on the package\ndisplayed in terminal" -index 0 -command {::Status {%t}}
::baltip::tip .t "There are two tags\nwith their own tips." -under 0
::baltip::tip .t "1st tag's tip!" -tag UnderLine1
::baltip::tip .t "2nd tag's tip!" -tag UnderLine2
::baltip::tip .cb "Switches all tips on/off\nexcept for balloons with \"-on yes\"."
::baltip::tip .lb {::LbxTip %i}
::baltip::tip .tre {::TreTip %i %c}   ;# per line & column
#::baltip::tip .lb {Listbox %i} -command {::SomeProc {%t}}
#::baltip::tip .tre {Treeview %i %c} -command {::SomeProc {%t}}   ;# Fire some proc
#::baltip::tip .tre {::TreTipId %i}   ;# per line
#::baltip::tip .tre {::TreTipC %c}   ;# per column
#::baltip::tip . "Testing tip for . path:\nsort of application tip.\n\nNot of much taste, though."

# ____________________________________ EOF ___________________________________ #

catch {source [file join ../transpops transpops.tcl]}
catch {::transpops::run ../transpops/demos/baltip/transpops.txt {<Alt-t> <Alt-y>} . white #055328}
