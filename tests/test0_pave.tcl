package require Tk

# This test 1 demonstrates how easily the standard dialog "Search & Replace"
# can be created by means of the pave.

if {$::tcl_platform(platform) == "windows"} {
  wm attributes . -alpha 0.0
} else {
  wm attributes . -type splash
  wm geometry . 0x0
}
ttk::style theme use clam
set pavedir [file normalize [file dirname $::argv0]]
source [file join $pavedir .. paveme.tcl]

PaveMe create pave
set win .win
pave makeWindow $win.fra "Find and Replace"
set v1 [set v2 1]
set c1 [set c2 [set c3 0]]
set en1 [set en2 ""]
pave window $win.fra {
  {lab1 - - 1 1    {-st es}  {-t "Find: "}}
  {ent1 lab1 L 1 9 {-st wes} {-tvar ::en1}}
  {lab2 lab1 T 1 1 {-st es}  {-t "Replace: "}}
  {ent2 lab2 L 1 9 {-st wes} {-tvar ::en2}}
  {labm lab2 T 1 1 {-st es} {-t "Match: "}}
  {radA labm L 1 1 {-st ws} {-t "Exact" -var ::v1 -value 1}}
  {radB radA L 1 1 {-st ws} {-t "Glob" -var ::v1 -value 2}}
  {radC radB L 1 1 {-st es} {-t "RE  " -var ::v1 -value 3}}
  {h_2 radC L 1 2  {-cw 1}}
  {h_3 labm T 1 9  {-st es -rw 1}}
  {seh  h_3 T 1 9  {-st ews}}
  {chb1 seh  T 1 2 {-st w} {-t "Match whole word only" -var ::c1}}
  {chb2 chb1 T 1 2 {-st w} {-t "Match case"  -var ::c2}}
  {chb3 chb2 T 1 2 {-st w} {-t "Wrap around" -var ::c3}}
  {sev1 chb1 L 3 1 }
  {lab3 sev1 L 1 2 {-st w} {-t "Direction:"}}
  {rad1 lab3 T 1 1 {-st we} {-t "Down" -var ::v2 -value 1}}
  {rad2 rad1 L 1 1 {-st we} {-t "Up"   -var ::v2 -value 2}}
  {sev2 ent1 L 8 1 }
  {but1 sev2 L 1 1 {-st we} {-t "Find" -com "::pave res $win 1"}}
  {but2 but1 T 1 1 {-st we} {-t "Find All" -com "::pave res $win 2"}}
  {but3 but2 T 1 1 {-st we} {-t "Replace"  -com "::pave res $win 3"}}
  {but4 but3 T 1 1 {-st nwe} {-t "Replace All" -com "::pave res $win 4"}}
  {seh3 but4 T 1 1 {-st ewn}}
  {but5 seh3 T 3 1 {-st we} {-t "Close" -com "::pave res $win 0"}}
}
set res [pave showModal $win -focus $win.fra.ent1 -geometry +200+200]
puts "
    Entry1=$en1
    Entry2=$en2
    E/G/R=$v1
    CheckBox1=$c1
    CheckBox2=$c2
    CheckBox3=$c3
    Direction=$v2
    Result=$res
    "
pave destroy
destroy $win

exit

