#! /usr/bin/env tclsh
#
# It's a test for baltip package.
# _______________________________________________________________________ #

cd [file dirname [info script]]
lappend auto_path .
package require baltip

# _______________________________________________________________________ #

proc ::butComm {} {
  ::baltip hide .b
  if {[incr ::ttt]%2} {
    puts "the button's tip disabled"; bell
    ::baltip tip .b "" -image TEST_TCL_IMAGE1 -compound right
    ::baltip update .l "      Danger!\n\nDon't trespass!" \
      -fg white -bg red -font "-weight bold" -padx 20 -pady 15 -global 0
  } else {
    puts "the button's tip enabled"; bell
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
      {*}[::baltip cget -fg -bg -font -padx -pady]
  }
  if {$::ttt>7} {set ::ttt -2}
}

proc ::chbComm {}  {
    puts "all tips [if $::on {set _ enabled} {set _ disabled}]"
    ::baltip config -global yes -on $::on -fg $::fg -bg $::bg
    ::baltip update .cb "After clicking:\nnew tip & options" \
      -fg maroon -padding 2 -padx 15 -pady 15 -global 0
    if {$::on} {::baltip repaint .cb}
}

# _______________________________________________________________________ #

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

set m [menu .popupMenu]
$m add command -label \
  "Global settings: -fg $::fg1 -bg $::bg1 -relief raised -alpha 0.8" -command " \
  ::baltip config -fg $::fg1 -bg $::bg1 -global yes -relief raised -alpha 0.8; \
  if {\[$m entryconfigure active\] eq {}} {::baltip repaint $m -index active}"
$m add command -label \
  "Global settings: -fg $::fg0 -bg $::bg0 -relief solid -alpha 1.0" -command " \
  ::baltip config -fg $::fg0 -bg $::bg0 -global yes -relief solid -alpha 1.0; \
  if {\[$m entryconfigure active\] eq {}} {::baltip repaint $m -index 2}"
bind .l <Button-3> {tk_popup .popupMenu %X %Y}

menu .menu -tearoff 0

set m .menu.file
menu $m -tearoff 0
.menu add cascade -label "File" -menu $m -underline 0
$m add command -label "Open..." -command {puts "\"Open...\" entry"}
$m add command -label "New" -command {puts "\"New\" entry"}
$m add command -label "Save" -command {puts "\"Save\" entry"}
$m add separator
$m add command -label "Exit" -command {exit}
set m .menu.help
menu $m -tearoff 0
.menu add cascade -label "Help" -menu $m -underline 0
$m add command -label "About" -command { \
  puts "\nWelcome to baltip v[package require baltip] at \
    \n  https://chiselapp.com/user/aplsimple \
    \n  https://github.com/aplsimple\n"}

text .t -width 24 -height 4
.t insert 1.0 "1st line: tag1\n2nd line: tag2\n3rd line: no tags"
.t tag configure UnderLine1 -font "-underline 1"
.t tag configure UnderLine2 -font "-weight bold"
.t tag add UnderLine1 1.10 1.15
.t tag add UnderLine2 2.10 2.15

set ::on 1
checkbutton .cb -text "Tips on" -variable ::on -command ::chbComm

pack .b .l .b2 .t .cb
. configure -menu .menu

::baltip::configure -per10 1200 -fade 300 -font {-size 11}
::baltip::tip .b "Hello, world!\nIt's me o Lord!" -under 0 -per10 3000 \
  -fg #a40000 -bg #bafaba -font {-weight bold -size 12} \
  -image TEST_TCL_IMAGE1 -compound left
::baltip::tip .l "Calls a popup tearoff menu.\nThis tip is switched by the button\nto an alert/message."
::baltip::tip .b2 "Displays a message at top right corner, having\
  \ncoordinates set with \"-geometry $geo\" option."
::baltip::tip .popupMenu "Sets new colors of all tips" -index 1
::baltip::tip .popupMenu "Restores colors of all tips" -index 2
::baltip::tip .menu "File actions" -index 0
::baltip::tip .menu "Help actions" -index 1
::baltip::tip .menu.file "Opens a file\n(stub)" -index 0
::baltip::tip .menu.file "Creates a file\n(stub)" -index 1
::baltip::tip .menu.file "Saves a file\n(stub)" -index 2
::baltip::tip .menu.file "Closes the test" -index 4
::baltip::tip .menu.help "About the package" -index 0
::baltip::tip .t "There are two tags\nwith their own tips." -under 0
::baltip::tip .t "1st tag's tip!" -tag UnderLine1
::baltip::tip .t "2nd tag's tip!" -tag UnderLine2
::baltip::tip .cb "Switches all tips on/off\nexcept for balloons with \"-on yes\"."

# _______________________________________________________________________ #

catch {source [file join ../transpops transpops.tcl]}
catch {::transpops::run ../transpops/demos/baltip/transpops.txt {<Alt-t> <Alt-y>} . white #055328}
