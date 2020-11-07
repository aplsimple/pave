lappend auto_path .
package require tooltip4

button .b -text Hello -command {
  ::tooltip4 hide .b
  ::tooltip4 update
  if {[incr ::ttt]%2} {
    puts "button's tooltip disabled"; bell
    ::tooltip4 too .b ""
    ::tooltip4 too .l "      Danger!\n\nDon't trespass!" \
      -fg white -bg red -font "-weight bold" -padx 20 -pady 15
  } else {
    puts "button's tooltip enabled"; bell
    ::tooltip4 config -fg black -bg #FBFB95 -padx 4 -pady 3 \
      -font "-size [expr {max(3,11-$::ttt/2)}] -weight normal"
    ::tooltip4 too .b "Hi again, world! \
      \nI feel [if $::ttt<2 {set _ great!} {set _ {smaller and smaller...}}]" \
      -force yes
    ::tooltip4 too .l "It's okay. Come on!" \
      {*}[::tooltip4 cget -fg -bg -font -padx -pady]
  }
  if {$::ttt>11} {set ::ttt -2}
  }
set geo +1500+30
set alpha 0.8
button .b2 -text "Balloon at $geo" -command {::tooltip4 too "" \
  "It's a stand-alone balloon\nto view in black & white \
  \nbold font and $alpha opacity." -alpha $alpha -fg white -bg black \
  -font {-weight bold -size 11} -per10 3000 -pause 1500 -fade 1500 -geometry $geo}
label .l -text "Dangerous corner"
pack .b .l .b2
::tooltip4::configure -per10 1200 -fade 300 -font {-size 11}
::tooltip4::tooltip .b "Hello, world!\nIt's me o Lord!"
::tooltip4::tooltip .b2 "Displays a message at top right corner, having\
  \ncoordinates set with \"-geometry $geo\" option."
puts "1 : [::tooltip4::cget]"
puts "2 : [::tooltip4::cget -fade -font]"
after 5000 {::tooltip4 config -on 0; puts "ALL disabled"; bell}
after 10000 {::tooltip4 config -on 1 -font {-weight bold}; puts "ALL enabled"; bell}
