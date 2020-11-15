# _______________________________________________________________________ #
#
# It's a Tcl/Tk tip widget inspired by:
#   https://wiki.tcl-lang.org/page/balloon+help
#
# See README.md for details.
#
# Scripted by Alex Plotnikov.
# License: MIT.
# _______________________________________________________________________ #

package provide baltip 0.6

package require Tk

namespace eval ::baltip {

  namespace export configure cget tip update hide repaint
  namespace ensemble create

  namespace eval my {
  variable ttdata; array set ttdata [list]
  set ttdata(on) yes
  set ttdata(wttip) "_baltip_"
  set ttdata(per10) 1600
  set ttdata(fade) 300
  set ttdata(pause) 600
  set ttdata(fg) black
  set ttdata(bg) #FBFB95
  set ttdata(bd) 1
  set ttdata(padx) 4
  set ttdata(pady) 3
  set ttdata(padding) 0
  set ttdata(alpha) 1.0
  set ttdata(bell) no
  set ttdata(font) [font actual TkDefaultFont]
  }
}

# _________________________ baltip UI procedures ______________________ #

proc ::baltip::configure {args} {
  # Configurates the tip for all widgets.
  #   args - options ("name value" pairs)
  # The following options are special:
  #   -force - if true, forces the display by 'tip' command
  #   -index - index of menu item to tip
  #   -tag - name of text tag to tip
  #   -geometry - geometry (+X+Y) of the balloon
  # Returns the list of -force, -geometry, -index, -tag option values.

  set force 0
  set index -1
  set geometry [set tag ""]
  foreach {n v} $args {
    set n1 [string range $n 1 end]
    switch -glob -- $n {
      -per10 - -fade - -pause - -fg - -bg - -bd - -alpha - -text - \
      -on - -padx - -pady - -padding - -bell {
        set my::ttdata($n1) $v
      }
      -font {foreach {k v} $v {dict set my::ttdata(font) $k $v}}
      -force - -geometry - -index - -tag {set $n1 $v}
      default {return -code error "invalid option \"$n\""}
    }
  }
  return [list $force $geometry $index $tag]
}
#_____

proc ::baltip::cget {args} {
  # Gets the tip's option values.
  #   args - option names (if empty, returns all options)
  # Returns a list of "name value" pairs.

  if {![llength $args]} {
    lappend args -on -per10 -fade -pause -fg -bg -bd -padx -pady -padding \
      -font -alpha -text -index -tag -bell
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

proc ::baltip::tip {w text args} {
  # Creates a tip for a widget.
  #   w - the parent widget's path
  #   text - the tip text
  #   args - options ("name value" pairs)

  if {[winfo exists $w] || $w eq ""} {
    set arrsaved [array get my::ttdata]
    set optvals [::baltip::my::CGet {*}$args]
    lassign $optvals forced geo index ttag
    set optvals [lrange $optvals 4 end]
    set my::ttdata(optvals,$w) [dict set optvals -text $text]
    set my::ttdata(on,$w) [expr {[string length $text]}]
    set my::ttdata(global,$w) no
    if {$text ne ""} {
      if {$forced || $geo ne ""} {::baltip::my::Show $w $text yes $geo $optvals}
      if {$geo ne ""} {
        array set my::ttdata $arrsaved  ;# balloon popup
      } else {
        set tags [bindtags $w]
        if {[lsearch -exact $tags "Tooltip$w"] == -1} {
          bindtags $w [linsert $tags end "Tooltip$w"]
        }
        bind Tooltip$w <Any-Leave>    [list ::baltip::hide $w]
        bind Tooltip$w <Any-KeyPress> [list ::baltip::hide $w]
        bind Tooltip$w <Any-Button>   [list ::baltip::hide $w]
        if {$index>-1} {
          set my::ttdata($w,$index) $text
          set my::ttdata(LASTMITEM) ""
          bind $w <<MenuSelect>> [list + ::baltip::my::MenuTip $w %W $optvals]
        } elseif {$ttag ne ""} {
          set ::baltip::my::ttdata($w,$ttag) "$text"
          $w tag bind $ttag <Enter> [list + ::baltip::my::TagTip $w $ttag $optvals]
          foreach event {Leave KeyPress Button} {
            $w tag bind $ttag <$event> [list + ::baltip::my::TagTip $w]
          }
        } else {
          bind Tooltip$w <Enter> [list ::baltip::my::Show %W $text no $geo $optvals]
        }
      }
    }
  }
}
#_____

proc ::baltip::update {{w ""}} {
  # Updates tips' settings according to the global settings.
  #   w - widget's path (if omitted, updates all widgets' tips
  # If the widget's path 'w' is set, shows the tip of this widget.

  if {$w eq ""} {
    foreach k [array names my::ttdata -glob on,*] {
      set w [lindex [split $k ,] 1]
      set my::ttdata(global,$w) yes
    }
  } else {
    set my::ttdata(global,$w) yes
    repaint $w
  }
}
#_____

proc ::baltip::hide {{w ""}} {
  # Destroys the tip's window.
  #   w - widget's path
  # Returns 1, if the window was really hidden.

  return [expr {![catch {destroy $w.$my::ttdata(wttip)}]}]
}
#_____

proc ::baltip::repaint {w} {
  # Repaints a tip immediately.
  #   w - widget's path

  if {[winfo exists $w] && [info exists my::ttdata(optvals,$w)] && \
  [dict exists $my::ttdata(optvals,$w) -text]} {
    after idle [list ::baltip::my::Show $w \
      [dict get $::baltip::my::ttdata(optvals,$w) -text] yes \
      {} $::baltip::my::ttdata(optvals,$w)]
  }
}

# _____________________ baltip internal procedures ____________________ #

proc ::baltip::my::CGet {args} {
  # Gets options' values, using local (args) and global (ttdata) settings.
  #   args - local settings ("name value" pairs)
  # Returns the full list of settings ("name value" pairs, "name" without "-") \
   in which -force and -geometry option values go first.

  variable ttdata
  set saved [array get ttdata]
  set res [::baltip::configure {*}$args]
  lappend res {*}[::baltip::cget]
  array set ttdata $saved
  return $res
}
#_____

proc ::baltip::my::ShowWindow {win geo} {
  # Shows a window of tip.
  #   win - the tip's window
  #   geo - being +X+Y, sets the tip coordinates

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

proc ::baltip::my::Show {w text force geo optvals} {
  # Creates and shows the tip's window.
  #   w - the widget's path
  #   text - the tip text
  #   force - if true, re-displays the existing tip
  #   geo - being +X+Y, sets the tip coordinates
  #   optvals - settings ("option value" pairs)

  variable ttdata
  if {$w ne "" && ![winfo exists $w]} return
  set win $w.$ttdata(wttip)
  set px [winfo pointerx .]
  set py [winfo pointery .]
  if {$ttdata(global,$w)} {
    array set data [::baltip::cget]
  } else {
    array set data $optvals
  }
  if {!$force && $geo eq "" && [winfo class $w] ne "Menu" && \
  ([winfo exists $win] || ![info exists ttdata(on,$w)] || !$ttdata(on,$w) || \
  ![string match $w [winfo containing $px $py]])} {
    return
  }
  ::baltip::hide $w
  if {![string length [string trim $text]] || !$ttdata(on) || !$data(-on)} return
  lappend ttdata(REGISTERED) $w
  foreach wold [lrange $ttdata(REGISTERED) 0 end-1] {::baltip::hide $wold}
  toplevel $win -bg $data(-bg) -class Tooltip$w
  catch {wm withdraw $win}
  wm overrideredirect $win 1
  wm attributes $win -topmost 1
  pack [label $win.label -text $text -justify left -relief solid \
    -bd $data(-bd) -bg $data(-bg) -fg $data(-fg) -font $data(-font) \
    -padx $data(-padx) -pady $data(-pady)] -padx $data(-padding) -pady $data(-padding)
  # defeat rare artifact by passing mouse over a tip to destroy it
  bindtags $win "Tooltip$win"
  bind $win <Any-Enter>  [list ::baltip::hide $w]
  bind Tooltip$win <Any-Enter>  [list ::baltip::hide $w]
  bind Tooltip$win <Any-Button> [list ::baltip::hide $w]
  set aint 20
  set fint [expr {int($data(-fade)/$aint)}]
  set icount [expr {int($data(-per10)/$aint*[string length $text]/10.0)}]
  set icount [expr {max(1000/$aint+1,$icount)}] ;# ~1 sec. be minimal
  if {$icount} {
    if {$geo eq ""} {
      catch {wm attributes $win -alpha $data(-alpha)}
    } else {
      ::baltip::my::Fade $win $aint [expr {round(1.0*$data(-pause)/$aint)}] \
        0 Un $data(-alpha) $geo 1
    }
    if {$force} {
      ::baltip::my::Fade $win $aint $fint $icount {} $data(-alpha) $geo 1
    } else {
      after $data(-pause) [list \
        ::baltip::my::Fade $win $aint $fint $icount {} $data(-alpha) $geo 1]
    }
  } else {
    # just showing, no fading
    after $data(-pause) [list ::baltip::my::ShowWindow $win $geo]
  }
  if {$data(-bell)} [list after [expr {$data(-pause)/4}] bell]
  array unset data
}
#_____

proc ::baltip::my::Fade {w aint fint icount Un alpha geo show {geo2 ""}} {
  # Fades/unfades the tip's window.
  #   w - the tip's window
  #   aint - interval for 'after'
  #   fint - interval for fading
  #   icount - counter of intervals
  #   Un - if equal to "Un", unfades the tip
  #   alpha - value of -alpha option
  #   geo - coordinates (+X+Y) of tip
  #   show - flag "show the window"
  #   geo2 - saved coordinates (+X+Y) of shown tip
  # See also: FadeNext, UnFadeNext

  update
  if {[winfo exists $w]} {
    after idle [list after $aint \
      [list ::baltip::my::${Un}FadeNext $w $aint $fint $icount $alpha $geo $show $geo2]]
  }
}
#_____

proc ::baltip::my::FadeNext {w aint fint icount alpha geo show {geo2 ""}} {
  # A step to fade the tip's window.
  #   w - the tip's window
  #   aint - interval for 'after'
  #   fint - interval for fading
  #   icount - counter of intervals
  #   alpha - value of -alpha option
  #   geo - coordinates (+X+Y) of tip
  #   show - flag "show the window"
  #   geo2 - saved coordinates (+X+Y) of shown tip
  # See also: Fade

  incr icount -1
  if {$show} {ShowWindow $w $geo}
  set show 0
  if {![winfo exists $w]} return
  lassign [split [wm geometry $w] +] -> X Y
  if {$geo2 ne "" && $geo2 ne "+$X+$Y"} return
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
  Fade $w $aint $fint $icount {} $alpha $geo $show +$X+$Y
}
#_____

proc ::baltip::my::UnFadeNext {w aint fint icount alpha geo show {geo2 ""}} {
  # A step to unfade the balloon's window.
  #   w - the tip's window
  #   aint - interval for 'after'
  #   fint - interval for fading
  #   icount - counter of intervals
  #   alpha - value of -alpha option
  #   geo - coordinates (+X+Y) of tip
  #   show - not used (here just for compliance with Fade)
  #   geo2 - not used (here just for compliance with Fade)
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
#_____

proc ::baltip::my::MenuTip {w wt optvals} {
  # Shows a menu's tip.
  #   w - the menu's path
  #   wt - the menu's path (incl. tearoff menu)
  #   optvals - settings of tip

  variable ttdata
  ::baltip::hide $w
  set index [$wt index active]
  set mit "$w/$index"
  if {$index eq "none"} return
	if {[info exists ttdata($w,$index)] && ([::baltip::hide $w] || \
  ![info exists ttdata(LASTMITEM)] || $ttdata(LASTMITEM) ne $mit)} {
    set text $ttdata($w,$index)
    ::baltip::my::Show $w $text no {} $optvals
  }
	set ttdata(LASTMITEM) $mit
}
#_____

proc ::baltip::my::TagTip {w {tag ""} {optvals ""}} {
  # Shows a text tag's tip.
  #   w - the text's path
  #   tag - the tag's name
  #   optvals - settings of tip

  variable ttdata
  ::baltip::hide $w
  if {$tag eq ""} return
  ::baltip::my::Show $w $ttdata($w,$tag) no {} $optvals
}

# ________________________________ EOF __________________________________ #
#RUNF1: ./test.tcl
#RUNF2: ../tests/test2_pave.tcl
