#! /usr/bin/env wish

###########################################################################
#
# Tests for PaveDialog and PaveInput (dialogs of pave, wrapper of grid).
#
###########################################################################

package require Tk

set pavedir [file join [file normalize [file dirname $::argv0]] ..]
source [file join $pavedir paveinput.tcl]

namespace eval t {

  variable textTags [list [list "dark" "-foreground black"] \
                          [list "b" "-font {-weight bold -size 14}"] \
                          [list "i" "-font {-slant italic -size 14}"] \
                          [list "red" "-foreground red"]]

  proc test1 {args} {
    return [dlg ok info "Dialog OK" \
      "Hey that Pushkin!\nHey that son of bitch!" -g +200+200 {*}$args]
  }

  proc test2 {args} {
    return [dlg yesno ques "Dialog YESNO" \
      "Hey that Pushkin!\nHey that son of bitch!
---
Do you agree?" YES -g +225+225 {*}$args]
  }

  proc test3 {args} {
    variable textTags
    set res [dlg okcancel "" "Dialog OKCANCEL" \
      " <dark>Hey that <red><b> Pushkin </b></red>!
 Hey that son of bitch!
 ---
 Do you agree? <i>Cancel</i> if not.</dark>
 " TEXT -g +250+250 -text 1 -tags textTags -width 30 -height 6 -bg white \
 -head "When presented at first\nit's a \"changeable text message\"." \
 -hsz "12 -slant italic -weight normal" {*}$args]
    set textTags [lreplace $textTags 0 0 [list "dark" "-foreground yellow"]]
    return $res
  }

  proc test4 {args} {
    return [dlg yesnocancel ques "Dialog YESNOCANCEL" \
      "Hey that Pushkin!\nHey that son of bitch!
---
Do you agree?
Or hate the question?
(Choose Cancel in such case)" YES -g +275+275 {*}$args]
  }

  proc test5 {args} {
    return [dlg retrycancel err "Dialog RETRYCANCEL" \
      "Hey that Pushkin!\nHey that son of bitch!
---
Retry the reading of Pushkin? Cancel if not." RETRY -g +300+300 {*}$args]
  }

  proc test6 {args} {
    return [dlg abortretrycancel err "Dialog ABORTRETRYCANCEL" \
      "Hey that Pushkin!\nHey that son of bitch!
---
Abort or retry the reading of Pushkin? Cancel if not sure." RETRY -g +325+325 {*}$args]
  }

  proc test7 {args} {
    return [dlg misc info "Dialog MSC" "\nAsk for HELLO\n" \
      {Hello 1 {Bye baby} 2 Misc3 3 Misc4 4 "Misc 5" 5 Cancel 0 } \
      1 -g +350+350 {*}$args]
  }

  proc test8 {args} {
    # initialize some variables - moved to -inpval option
    #set var1 [dlg varname cbx1]
    #set var2 [dlg varname fco1]
    #if {![info exists $var1]} {
      #set $var1 {Mother}
      #set $var2 {Content of test2_fco.dat}
    #}
    return [dlg input - "Dialog INPUT" {
      seh1 {{} {-pady 9}} {}
      ent1 {{Enter general info........}} {}
      fil1 {{Choose a file to read.....}} {}
      fis1 {{Choose a file to save.....}} {}
      dir1 {{Choose a directory........}} {}
      fon1 {{Choose a font.............}} {}
      clr1 {{Choose a color............}} {}
      dat1 {{Choose a date.............}} {}
      seh2 {{} {-pady 9}} {}
      chb1 {{Check the demo checkbox...}} {}
      rad1 {{Check the radio button....}} {Big Giant Big Small "None of these"}
      seh3 {{} {-pady 9}} {}
      spx1 {{Spinbox from 0 to 99......} {} {-from 0 -to 99}} {}
      cbx1 {{Combobox of relations.....} {} {-h 7 -inpval Mother}} {Son Father Mother Son Daughter Brother Sister Uncle Aunt Cousin "Second cousin" "1000th cousin"}
      fco1 {{Combobox of file content..} {} {-h 7 -inpval {test2_fco.dat}}} {/@-div1 " \[" -div2 "\] " -ret 1 test2_fco.dat/@ \
        INFO: /@-pos 22 -list {{test2_fco.dat} {other item} trunk DOC} test2_fco.dat/@}
      seh4 {{} {-pady 9}} {}
      tex1 {{Text field................} {} {-h 4 -w 55}} {It's a sample of
multiline entry field aka
- text\n- memo\n- note}
    } -size 14 -weight bold -head "Entries, choosers, switchers, boxes..." {*}$args]
  }

}

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

# firstly show dialogs without checkboxes
PaveInput create dlg "" $pavedir

set dn "Don't show this again"
puts "ok  = [t::test1 -weight bold -size 8 -text 1]"
puts "yn  = [t::test2 -weight bold -size 10 -text 1 -ch $dn]"
puts "oc  = [t::test3 -weight bold -size 12 -bg #ffffc4 -ro 0]"
puts "ync = [t::test4 -weight bold -size 14 -text 1 -width 30 -height 6 -fg green]"
puts "rc  = [t::test5 -weight bold -size 16]"
puts "arc = [t::test6 -weight bold -size 18]"
puts "msc = [t::test7 -size 20]"
puts "inp = [t::test8 -g +375+375]"

dlg themingWindow . \
  white #364c64 #d2d2d2 #292a2a white #4a6984 grey #364c64 #02ffff #00a0f0

# show dialogs with checkboxes, in cycle
lassign {0 0 0 0 0 0 0 0} r1 r2 r3 r4 r5 r6 r7 r8
while 1 {
  puts --------------------------------
  set totr 0
  foreach {n type} {1 OK 2 YN 3 OC 4 YNC 5 RC 6 ARC 7 MSC 8 INP} {
    eval "if \{\$r$n < 10\} \{set r$n \[lindex \[t::test$n -ch \
         \"\$dn\"\] 0\]\}; puts \"$type = \$r$n\" ; incr totr \[expr \$r$n / 10\]"
  }
  ;# cycle till none be shown
  if {$totr >= 8} break
  # ask for continuation anyway
  if {[lindex [dlg yesno warn "UFF..." "\n Break the dance? \n" NO \
      -g +350+350 -weight bold -size 22 -c "ghost white"] 0] == 1} {
    break
  }
}
PaveInput  destroy
exit
