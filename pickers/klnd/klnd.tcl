#! /usr/bin/env tclsh
# _______________________________________________________________________ #
#
# A calendar widget for apave package.
#
# See pkgIndex.tcl for details.
# _______________________________________________________________________ #

package require Tk
package require msgcat
package provide ::apave::klnd 0.1

namespace eval ::apave {}
namespace eval ::apave::klnd {

  variable p
  variable locales
  # localized 1st day of week: %u means Mon, %w means Sun (default)
  array set locales [list \
    en_uk %u \
    en_us %w \
    ru_ru %u \
    ru_ua %u \
    uk_ua %u \
    be_by %u \
  ]
  array set p [list pobj APAVE_CLND FINT %Y/%m/%d days {} months {} \
    d 0 m 0 y 0 ddisp 0 mdisp 0 ydisp 0 icurr 0 ienter 0 weekday ""]
}

# _______________________________________________________________________ #

proc ::apave::klnd::CurrentDate {} {
  # Gets the current date.

  variable p
  set sec [clock seconds]
  lassign [split [clock format $sec -format $p(FINT)] /] p(y) p(m) p(d)
  return $sec
}

proc ::apave::klnd::InitCalendar {} {

  variable p
  variable locales
  package require msgcat
  lassign [::apave::obj csGet] - p(fg1) - p(bg1) - p(bg) p(fg) - - p(fgh) - - - - p(fg2) p(bg2)
  CurrentDate
  set p(ydisp) $p(y)
  set p(mdisp) $p(m)
  set p(ddisp) $p(d)
  # get localized setting of 1st week day
  set loc [lindex [msgcat::mcpreferences] 0]
  if {$p(weekday) eq ""} {
    if {[array names locales $loc] ne ""} {
      set p(weekday) $locales($loc)
    } else {
      set p(weekday) %u
    }
  }
  # get localized week day names
  set p(days) [list]
  foreach i {0 1 2 3 4 5 6} {
    lappend p(days) [clock format [clock scan "06/[expr {22+$i}]/1941" -format %D] \
      -format %a -locale $loc]
  }
  if {$p(weekday) eq "%u"} {
    set d1 [lindex $p(days) 0]
    set p(days) [list {*}[lrange $p(days) 1 end] $d1]
  }
  # get localized month names
  set p(months) [list]
  foreach i {01 02 03 04 05 06 07 08 09 10 11 12} {
    lappend p(months) [clock format [clock scan "$i/01/1941" -format %D] \
      -format %B -locale $loc]
  }
}

proc ::apave::klnd::ShowMonth {m y} {

  variable p
  set sec [CurrentDate]
  ::baltip::tip [$p(pobj) BuT_IM_AP_0] "Current date (F3)
[clock format $sec -format %x]" -under 5
  [$p(pobj) LabMonth] configure -text  "[lindex $p(months) [expr {$m-1}]] $y"
  for {set i 1} {$i<8} {incr i} {
    [$p(pobj) LabDay$i] configure -text "   [lindex $p(days) $i-1]   "
  }
  set i0 [clock format [clock scan "$m/1/$y" -format %D] -format %w]
  if {$p(weekday) eq "%u"} {if {$i0} {incr i0 -1} {set i0 6}}
  if {[set yl $y] && [set ml $m]==12} {set ml 1; incr yl}
  set lday [clock format [clock scan "[incr ml]/1/$yl 1 day ago"] -format %d]
  set iday [set p(icurr) 0]
  for {set i 1} {$i<38} {incr i} {
    if {$i<=$i0 || $iday>=$lday} {
      set att "-takefocus 0 -text {    } -activeforeground $p(bg1) -activebackground $p(bg1)"
    } else {
      set att "-takefocus 1 -text {[incr iday]} -activeforeground $p(fg) -activebackground $p(bg)"
      if {$iday==$p(ddisp) || ($iday==$lday && $iday<$p(ddisp))} {
        catch {after cancel $p(after)}
        set p(after) [after 100 "::apave::klnd::Enter $i; ::apave::klnd::HighlightCurrentDay"]
      }
    }
    [$p(pobj) BuTSTD$i] configure {*}$att -foreground $p(fg1) -background $p(bg1)
    if {$y==$p(y) && $m==$p(m) && $iday==$p(d)} {set p(icurr) $i}
  }
  set p(mdisp) $m
  set p(ydisp) $y
}

proc ::apave::klnd::GoYear {i {dobreak no}} {

  variable p
  ShowMonth $p(mdisp) [expr {$p(ydisp)+($i)}]
  if {$dobreak} {return -code break}
}

proc ::apave::klnd::GoMonth {i {dobreak no}} {

  variable p
  set m [expr {$p(mdisp)+($i)}]
  if {$m>12} {set m 1; incr p(ydisp)}
  if {$m<1} {set m 12; incr p(ydisp) -1}
  ShowMonth $m $p(ydisp)
  if {$dobreak} {return -code break}
}

proc ::apave::klnd::SetCurrentDay {} {

  variable p
  set p(ddisp) 0
  ShowMonth $p(m) $p(y)
  Enter $p(icurr)
}

proc ::apave::klnd::KeyPress {i K} {

  variable p
  Leave $i
  switch $K {
    Left {set n [expr {$i-1}]}
    Right {set n [expr {$i+1}]}
    Up {set n [expr {$i-7}]}
    Down {set n [expr {$i+7}]}
    Enter - Return - space {$p(pobj) res $p(win) 1; return}
    default return
  }
  if {![catch {set w [$p(pobj) BuTSTD$n]}] && [$w cget -takefocus]} {
    Enter $n
  } elseif {$K in {Left Up}} {
    GoMonth -1
  } else {
    GoMonth 1
  }
}

proc ::apave::klnd::EnterByMouse {i} {

  variable p
  if {[[$p(pobj) BuTSTD$i] cget -takefocus]} {
    Leave
    Enter $i
  }
}

proc ::apave::klnd::Enter {i} {

  variable p
  [set w [$p(pobj) BuTSTD$i]] configure -foreground $p(fg) -background $p(bg)
  after 10 "if \[winfo exists $w\] {focus $w}"
  set p(ienter) $i
  set p(ddisp) [$w cget -text]
}

proc ::apave::klnd::Leave {{i 0}} {

  variable p
  if {$i && ![[$p(pobj) BuTSTD$i] cget -takefocus]} return
  foreach n [list $i $p(ienter)] {
    if {$n} {
      [$p(pobj) BuTSTD$n] configure -foreground $p(fg1) -background $p(bg1)
      [$p(pobj) BuTSTD$n] configure -foreground $p(fg1) -background $p(bg1)
    }
  }
  ::apave::klnd::HighlightCurrentDay
}

proc ::apave::klnd::HighlightCurrentDay {} {

  variable p
  catch {
    [$p(pobj) BuTSTD$p(icurr)] configure -foreground $p(fg2) -background $p(bg2)
  }
}

# _______________________________________________________________________ #

proc ::apave::klnd::calendar {args} {

  variable p
  # get arguments
  lassign [::apave::parseOptions $args \
    -value "" -parent "" -title "Calendar" -dateformat %D -weekday ""] \
    datevalue parent title dformat p(weekday)
  InitCalendar
  foreach {i icon} {0 date 1 previous2 2 previous 3 next 4 next2} {
    image create photo IM_AP_$i -data [::apave::iconData $icon]
  }
  if {$parent eq ""} {
    set geo "-geometry +[expr {[winfo pointerx .]+10}]+[expr {[winfo pointery .]+10}]"
  } else {
    set geo "-centerme $parent"
  }
  set parent [string trimright $parent .]
  set win [set p(win) "$parent.apave_CALENDAR_"]
  catch {$p(pobj) destroy}
  ::apave::APaveInput create $p(pobj) $win
  set p(font) [$p(pobj) boldTextFont]
  $p(pobj) makeWindow $win.fra $title
  $p(pobj) paveWindow $win.fra {
    {fraTool - - 1 10 {-st new} {}}
    {fraTool.tool - - - - {pack -side top} {-array {
      IM_AP_0 {::apave::klnd::SetCurrentDay}
      sev 6
      IM_AP_1 {{::apave::klnd::GoYear -1} -tooltip "Previous year (Alt+Left)@@-under 5"}
      h_ 2
      IM_AP_2 {{::apave::klnd::GoMonth -1} -tooltip "Previous month (Ctrl+Left)@@-under 5"}
      h_ 3
      LabMonth {"" {-fill x -expand 1} {-anchor center -font {$::apave::klnd::p(font)}}}
      h_ 2
      IM_AP_3 {{::apave::klnd::GoMonth 1} -tooltip "Next month (Ctrl+Right)@@-under 5"}
      h_ 3
      IM_AP_4 {{::apave::klnd::GoYear 1} -tooltip "Next year (Alt+Right)@@-under 5"}
      h_ 2
    }}}
    {fraDays fraTool T - - {-st nsew}}
    {fraDays.tcl {
      set wt -
      for {set i 1} {$i<45} {incr i} {
        if {$i<8} {set cur "fraDays.LabDay$i"} {set cur "fraDays.BuTSTD[expr {$i-7}]"}
        if {($i%7)!=1} {set p L; set pw $pr} {set p T; set pw $wt; set wt $cur}
        if {$i<8} {
          set lwid "$cur $pw $p 1 1 {-st ew} {-anchor center -foreground $::apave::klnd::p(fgh)}"
        } else {
          set lwid "$cur $pw $p 1 1 {-st ew} {-t {    } -bd 0 -takefocus 0 -pady 2 -highlightthickness 0 -activeforeground $::apave::klnd::p(fg) -activebackground $::apave::klnd::p(bg)}"
        }
        %C $lwid
        set pr $cur
      }
    }}
    {seh FraDays T 1 10 {-pady 4}}
    {fraBottom seh T - - {-st ew}}
    {fraBottom.h_ - - - - {pack -fill both -expand 1 -side left} {}}
    {fraBottom.ButClose - - - - {pack -side left} {-t Close -com "::apave::klnd::$p(pobj) res $win 0"}}
  }
#  $p(pobj) untouchWidgets *fraDays.buTSTD*
  foreach {ev prc} { <Alt-Left> "::apave::klnd::GoYear -1 yes" \
  <Alt-Right> "::apave::klnd::GoYear 1 yes" \
  <Control-Left> "::apave::klnd::GoMonth -1 yes" \
  <Control-Right> "::apave::klnd::GoMonth 1 yes"} {
    for {set i 1} {$i<38} {incr i} {
      set but [$p(pobj) BuTSTD$i]
      bind $but $ev $prc
      bind $but <Enter> "::apave::klnd::EnterByMouse $i"
      bind $but <Leave> "::apave::klnd::Leave $i"
      bind $but <KeyPress> "::apave::klnd::KeyPress $i %K"
      bind $but <Double-1> "::apave::klnd::$p(pobj) res $win 1"
    }
    bind [$p(pobj) ButClose] $ev $prc
  }
  bind $win <F3> ::apave::klnd::SetCurrentDay
  if {![catch {set ym [clock scan $datevalue -format $dformat]}]} {
    set m [clock format $ym -format %N]
    set y [clock format $ym -format %Y]
    set p(ddisp) [clock format $ym -format %e]
  } else {
    set m $p(m)
    set y $p(y)
  }
  after idle "::apave::klnd::ShowMonth $m $y"
  set res [$p(pobj) showModal $win -decor 1 -resizable {0 0} -focus "" {*}$geo]
  if {$res && $p(ddisp)} {
    set res [clock format [clock scan $p(mdisp)/$p(ddisp)/$p(ydisp) -format %D] -format $dformat]
  } else {
    set res ""
  }
  $p(pobj) destroy
  destroy $win
  return $res
}

# _________________________________ EOF _________________________________ #

#RUNF1: ../../tests/test2_pave.tcl 1 13 12 'small icons'
