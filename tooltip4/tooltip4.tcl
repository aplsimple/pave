# _______________________________________________________________________ #
#
# It's a Tcl/Tk tooltip widget inspired by:
#   https://wiki.tcl-lang.org/page/balloon+help
#
# See README.md for details.
#
# Scripted by Alex Plotnikov.
# License: MIT.
# _______________________________________________________________________ #

package provide tooltip4 0.5.1

package require Tk

namespace eval ::tooltip4 {

  namespace export tooltip configure cget update hide repaint
  namespace ensemble create

  namespace eval my {
  variable ttdata; array set ttdata [list]
  set ttdata(on) yes
  set ttdata(wttip) "__tooltip4__"
  set ttdata(per10) 1600
  set ttdata(fade) 400
  set ttdata(pause) 600
  set ttdata(fg) black
  set ttdata(bg) #FBFB95
  set ttdata(bd) 1
  set ttdata(padx) 4
  set ttdata(pady) 3
  set ttdata(padding) 0
  set ttdata(alpha) 1.0
  set ttdata(text) ""
  set ttdata(font) [font actual TkDefaultFont]
  }
}

# _________________________ tooltip4 UI procedures ______________________ #

proc ::tooltip4::configure {args} {
  # Configurates the tooltip for all widgets.
  #   args - options ("name value" pairs)
  # The following options are available:
  #    -on    - switches all tooltips on/off
  #    -force - if true, forces the display by 'tooltip' command
  #    -per10 - a pause for each 10 characters of the tooltip (in millisec.)
  #    -fade  - a time of fading (in millisec.)
  #    -pause - a pause before displaying tooltips (in millisec.)
  #    -alpha - an opacity (from 0.0 to 1.0)
  #    -fg    - foreground of tooltips
  #    -bg    - background of tooltips
  #    -bd    - borderwidth of tooltips
  #    -font  - font attributes
  #    -padx - x-padding for text
  #    -pady - y-padding for text
  #    -padding - padding for pack
  #    -geometry - geometry (+X+Y) of the tooltip
  # Returns the list of -force and -geometry option values.

  set force 0
  set geo ""
  foreach {n v} $args {
    switch -glob -- $n {
      -on - -per10 - -fade - -pause - -fg - -bg - -bd - -alpha - -text - \
      -padx - -pady - -padding {set my::ttdata([string range $n 1 end]) $v}
      -font {foreach {k v} $v {dict set my::ttdata(font) $k $v}}
      -force {set force $v}
      -geometry {set geo $v}
      default {return -code error "invalid option \"$n\""}
    }
  }
  return [list $force $geo]
}
#_____

proc ::tooltip4::cget {args} {
  # Gets the tooltip's option values.
  #   args - option names (if empty, returns all options)
  # Returns a list of "name value" pairs.

  if {![llength $args]} {
    lappend args -on -per10 -fade -pause -fg -bg -bd -padx -pady -padding \
      -font -alpha -text
  }
  set res [list]
  foreach n $args {
    set n [string range $n 1 end]
    if {[info exists my::ttdata($n)]} {
      lappend res -$n $my::ttdata($n)
    }
  }
  return $res
}
#_____

proc ::tooltip4::tooltip {w text args} {
  # Creates a tooltip for a widget.
  #   w - the parent widget's path
  #   text - the tooltip text
  #   args - options ("name value" pairs)

  if {[winfo exists $w] || $w eq ""} {
    set arrsaved [array get my::ttdata]
    set optvals [::tooltip4::my::CGet {*}$args]
    lassign $optvals forced geo
    set optvals [lrange $optvals 2 end]
    set my::ttdata(optvals,$w) [dict set optvals -text $text]
    set my::ttdata(on,$w) [expr {[string length $text]}]
    set my::ttdata(global,$w) no
    if {$text ne ""} {
      if {$forced || $geo ne ""} {::tooltip4::my::Show $w $text yes $geo $optvals}
      if {$geo ne ""} {
        array set my::ttdata $arrsaved  ;# balloon popup
      } else {
        set tags [bindtags $w]
        if {[lsearch -exact $tags "Tooltip$w"] == -1} {
          bindtags $w [linsert $tags end "Tooltip$w"]
        }
        bind Tooltip$w <Enter>        [list ::tooltip4::my::Show %W $text no $geo $optvals]
        bind Tooltip$w <Any-Leave>    [list ::tooltip4::hide $w]
        bind Tooltip$w <Any-KeyPress> [list ::tooltip4::hide $w]
        bind Tooltip$w <Any-Button>   [list ::tooltip4::hide $w]
      }
    }
  }
}
#_____

proc ::tooltip4::update {{w ""}} {
  # Updates tooltips' settings according to the global settings.
  #   w - widget's path (if omitted, updates all widgets' tooltips)

  if {$w eq ""} {
    foreach k [array names my::ttdata -glob on,*] {
      set w [lindex [split $k ,] 1]
      set my::ttdata(global,$w) yes
    }
  } else {
    set my::ttdata(global,$w) yes
  }
}
#_____

proc ::tooltip4::hide {{w ""}} {
  # Destroys the tooltip's window.
  #   w - the tooltip's parent window

  if {[winfo exists $w] || $w eq ""} {
    catch {destroy $w.$my::ttdata(wttip)}
  }
}
#_____

proc ::tooltip4::repaint {w} {
  # Repaints a tooltip immediately.
  #   w - widget's path

  if {[winfo exists $w] && [info exists my::ttdata(optvals,$w)]} {
    ::tooltip4::my::Show $w [dict get $my::ttdata(optvals,$w) -text] yes \
      {} $my::ttdata(optvals,$w)
  }
}

# _____________________ tooltip4 internal procedures ____________________ #

proc ::tooltip4::my::CGet {args} {
  # Gets options' values, using local (args) and global (ttdata) settings.
  #   args - local settings ("name value" pairs)
  # Returns the full list of settings ("name value" pairs, "name" without "-") \
   in which -force and -geometry option values go first.

  variable ttdata
  set saved [array get ttdata]
  set res [::tooltip4::configure {*}$args]
  lappend res {*}[::tooltip4::cget]
  array set ttdata $saved
  return $res
}
#_____

proc ::tooltip4::my::ShowWindow {win geo} {
  # Shows a window of tooltip.
  #   win - the tooltip's window
  #   geo - being +X+Y, sets the tooltip coordinates

  if {![winfo exists $win]} return
  set w [winfo parent $win]
  set px [winfo pointerx .]
  set py [winfo pointery .]
  set width [winfo reqwidth $win.label]
  set height [winfo reqheight $win.label]
  set ady 0
  if {[catch {set wheight [winfo height $w]}]} {
    set wheight 0
  } else {
    for {set i 0} {$i<$wheight} {incr i} {  ;# find the widget's bottom
      incr py
      incr ady
      if {![string match $w [winfo containing $px $py]]} break
    }
  }
  if {$geo eq ""} {
    set x [expr {max(1,$px - round($width / 2.0))}]
    set y [expr {$py + 16 - $ady}]
  } else {
    lassign [split $geo +] -> x y
    set x [expr [string map "W $width" $x]]  ;# W to shift horizontally
    set y [expr [string map "H $height" $y]] ;# H to shift vertically
    set py [expr {$y-16}]
  }
  # check for edges of screen incl. decors
  set scrw [winfo screenwidth .]
  set scrh [winfo screenheight .]
  if {($x + $width) > $scrw}  {set x [expr {$scrw - $width - 1}]}
  if {($y + $height) > ($scrh-36)} {set y [expr {$py - $wheight - $height}]}
  wm geometry $win [join  "$width x $height + $x + $y" {}]
  catch {wm deiconify $win ; raise $win}
}
#_____

proc ::tooltip4::my::Show {w text force geo optvals} {
  # Creates and shows the tooltip's window.
  #   w - the parent widget's path
  #   text - the tooltip text
  #   force - if true, re-displays the existing tooltip
  #   geo - being +X+Y, sets the tooltip coordinates
  #   optvals - settings ("option value" pairs)

  variable ttdata
  if {$w ne "" && ![winfo exists $w]} return
  set win $w.$ttdata(wttip)
  set px [winfo pointerx .]
  set py [winfo pointery .]
  if {$ttdata(global,$w)} {
    array set data [::tooltip4::cget]
  } else {
    array set data $optvals
  }
  if {!$force && $geo eq "" && ([winfo exists $win] || \
  ![info exists ttdata(on,$w)] || !$ttdata(on,$w) || \
  ![string match $w [winfo containing $px $py]] || \
  !$ttdata(on) || !$data(-on))} {
    return
  }
  ::tooltip4::hide $w
  if {![string length [string trim $text]]} return
  lappend ttdata(REGISTERED) $w
  foreach wold [lrange $ttdata(REGISTERED) 0 end-1] {
    ::tooltip4::hide $wold
  }
  toplevel $win -bg $data(-bg) -class Tooltip$w
  catch {wm withdraw $win}
  wm overrideredirect $win 1
  wm attributes $win -topmost 1
  pack [label $win.label -text $text -justify left -relief solid \
    -bd $data(-bd) -bg $data(-bg) -fg $data(-fg) -font $data(-font) \
    -padx $data(-padx) -pady $data(-pady)] -padx $data(-padding) -pady $data(-padding)
  # defeat rare artifact by passing mouse over a tooltip to destroy it
  bindtags $win "Tooltip$win"
  bind Tooltip$win <Enter>    [list ::tooltip4::hide $w]
  bind Tooltip$win <Button>   [list ::tooltip4::hide $w]
  set aint 20
  set fint [expr {int($data(-fade)/$aint)}]
  set icount [expr {int($data(-per10)/$aint*[string length $text]/10.0)}]
  if {$icount} {
    if {$geo eq ""} {
      catch {wm attributes $win -alpha $data(-alpha)}
    } else {
      ::tooltip4::my::Fade $win $aint [expr {round(1.0*$data(-pause)/$aint)}] \
        0 Un $data(-alpha) $geo 1
    }
    after $data(-pause) [list \
      ::tooltip4::my::Fade $win $aint $fint $icount {} $data(-alpha) $geo 1]
  } else {
    # just showing, no fading
    after $data(-pause) [list ::tooltip4::my::ShowWindow $win $geo]
  }
  array unset data
}
#_____

proc ::tooltip4::my::Fade {w aint fint icount Un alpha geo show} {
  # Fades/unfades the tooltip's window.
  #   w - the tooltip's window
  #   aint - interval for 'after'
  #   fint - interval for fading
  #   icount - counter of intervals
  #   Un - if equal to "Un", unfades the tooltip
  #   alpha - value of -alpha option
  #   geo - coordinates (+X+Y) of tooltip
  #   show - flag "show the window"
  # See also: FadeNext, UnFadeNext

  update
  if {[winfo exists $w]} {
    after idle [list after $aint \
      [list ::tooltip4::my::${Un}FadeNext $w $aint $fint $icount $alpha $geo $show]]
  }
}
#_____

proc ::tooltip4::my::FadeNext {w aint fint icount alpha geo show} {
  # A step to fade the tooltip's window.
  #   w - the tooltip's window
  #   aint - interval for 'after'
  #   fint - interval for fading
  #   icount - counter of intervals
  #   alpha - value of -alpha option
  #   geo - coordinates (+X+Y) of tooltip
  #   show - flag "show the window"
  # See also: Fade

  incr icount -1
  if {$show} {
    ShowWindow $w $geo
    set show 0
  }
  if {$icount<0} {
    set al [expr {min($alpha,($fint+$icount*1.5)/$fint)}]
    if {$al>0} {
      if {[catch {wm attributes $w -alpha $al}]} {set al 0}
    }
    if {$al<=0 || ![winfo exists $w]} {
      catch {destroy $w}
      return
    }
  }
  Fade $w $aint $fint $icount {} $alpha $geo $show
}
#_____

proc ::tooltip4::my::UnFadeNext {w aint fint icount alpha geo show} {
  # A step to unfade the tooltip's window.
  #   w - the tooltip's window
  #   aint - interval for 'after'
  #   fint - interval for fading
  #   icount - counter of intervals
  #   alpha - value of -alpha option
  #   geo - coordinates (+X+Y) of tooltip
  #   show - not used (here just for compliance with Fade)
  # See also: Fade

  incr icount
  set al [expr {min($alpha,$icount*1.5/$fint)}]
  if {$al<$alpha && [catch {wm attributes $w -alpha $al}]} {set al 1}
  if {$show} {
    ShowWindow $w $geo
    set show 0
  }
  if {[winfo exists $w] && $al<$alpha} {
    Fade $w $aint $fint $icount Un $alpha $geo 0
  }
}

# ________________________________ EOF __________________________________ #
#RUNF1: ../tests/test2_pave.tcl
