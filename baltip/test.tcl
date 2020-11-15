lappend auto_path .
package require baltip

button .b -text Hello -command {
  ::baltip hide .b
  ::baltip update
  if {[incr ::ttt]%2} {
    puts "the button's tip disabled"; bell
    ::baltip tip .b ""
    ::baltip tip .l "      Danger!\n\nDon't trespass!" \
      -fg white -bg red -font "-weight bold" -padx 20 -pady 15
  } else {
    puts "the button's tip enabled"; bell
    ::baltip config -fg black -bg #FBFB95 -padx 4 -pady 3 \
      -font "-size [expr {max(3,11-$::ttt/2)}] -weight normal"
    ::baltip tip .b "Hi again, world! \
      \nI feel [if $::ttt<2 {set _ great!} {set _ {smaller and smaller...}}]" \
      -force yes
    ::baltip tip .l "It's okay. Come on!" \
      {*}[::baltip cget -fg -bg -font -padx -pady]
  }
  if {$::ttt>11} {set ::ttt -2}
}

set geo +999999+30  ;# 999999 to get it the most right
set alpha 0.8
button .b2 -text "Balloon at $geo" -command {::baltip tip "" \
  "It's a stand-alone balloon\nto view in black & white \
  \nbold font and $alpha opacity." -alpha $alpha -fg white -bg black \
  -font {-weight bold -size 11} -per10 1400 -pause 1500 -fade 1500 \
  -geometry $geo -bell yes}

label .l -text "Click me (tearoff popup)"

set m [menu .popupMenu]
$m add command -label "Popup menu item 1" -command bell
$m add command -label "Popup menu item 2" -command bell
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
$m add command -label "About" -command {puts "baltip v[package require baltip]"}

text .t -width 24 -height 4
.t insert 1.0 "1st line: tag1\n2nd line: tag2\n3rd line: no tags"
.t tag configure UnderLine1 -font "-underline 1"
.t tag configure UnderLine2 -font "-weight bold"
.t tag add UnderLine1 1.10 1.15
.t tag add UnderLine2 2.10 2.15

set ::on 1
checkbutton .cb -text "Tips on" -variable ::on \
  -command {::baltip config -on [expr {$::on}]; \
  puts "all tips [if $::on {set _ enabled} {set _ disabled}]"; \
  ::baltip update .cb}

pack .b .l .b2 .t .cb
. configure -menu .menu

::baltip::configure -per10 1200 -fade 300 -font {-size 11}
::baltip::tip .b "Hello, world!\nIt's me o Lord!"
::baltip::tip .l "Calls a popup tearoff menu.\nThis tip is switched by the button\nto an alert/message."
::baltip::tip .b2 "Displays a message at top right corner, having\
  \ncoordinates set with \"-geometry $geo\" option."
::baltip::tip .popupMenu "First" -index 1
::baltip::tip .popupMenu "2nd" -index 2
::baltip::tip .menu "File actions" -index 0
::baltip::tip .menu "Help actions" -index 1
::baltip::tip .menu.file "Opens a file\n(stub)" -index 0
::baltip::tip .menu.file "Creates a file\n(stub)" -index 1
::baltip::tip .menu.file "Saves a file\n(stub)" -index 2
::baltip::tip .menu.file "Closes the test" -index 4
::baltip::tip .menu.help "About the package" -index 0
::baltip::tip .t "There are two tags\nwith their own tips."
::baltip::tip .t "1st tag's tip!" -tag UnderLine1
::baltip::tip .t "2nd tag's tip!" -tag UnderLine2
::baltip::tip .cb "Switches all tips on/off."

puts "1 : [::baltip::cget]"
puts "2 : [::baltip::cget -fade -font]"
