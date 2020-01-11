#! /usr/bin/env wish

lappend auto_path ".."; package require apave

ttk::style theme use clam

apave::initWM
set win .win
set winf $win.fra
apave::APaveDialog create pdlg
pdlg makeWindow $winf "Adding Shortcuts"
pdlg themingWindow . \
  white #364c64 #d2d2d2 #292a2a white #4a6984 #182020 #dcdad5 #02ffff #00a0f0
set fontbold "-font \"-weight bold\""
pdlg window $winf {
  {frAU - - 1 6   {-st new} {-relief groove -borderwidth 1}}
  {frAU.v_00 - - 1 1}
  {frAU.laB0 frAU.v_00 T 1 1 {} {-t "This TKE plugin allows you to create the shortcuts bound to existing ones. Thus you can enable localized shortcuts."}}
  {frAU.laB1 frAU.laB0 T 1 1 {} {-t "You can also make a miscellany that contains: event handler(s), menu invoker(s), command caller(s)."}}
  {frAU.laB2 frAU.laB1 T 1 1 {} {-t "Press the shortcut in the ID field. Confirm your choice by pressing Enter / Return key."}}
  {frAU.v_0 frAU.laB2 T 1 1}
  {v_0 frAU T 1 6}
  {laB1 v_0 T 1 2 {} {-t " Group info " $fontbold}}
  {laB2 laB1 T 1 1 {-st e} {-t "Name:"}}
  {entOrig laB2 L 1 1 {-st we -padx 5 -cw 3} {-tvar adsh__No}}
  {v_1 laB2 T 1 2}
  {laB3 v_1 T 1 1 {} {-t " Shortcut info " $fontbold}}
  {laB4 laB3 T 1 1 {-st e} {-t "Name:"}}
  {entName laB4 L 1 1 {-st we -padx 5} {-tvar adsh__Na}}
  {laB5 laB4 T 1 1 {-st e} {-t "Shortcut ID:"}}
  {entID laB5 L 1 1 {-st we -padx 5} {-tvar adsh__ID -state readonly}}
  {v_2 laB5 T 1 1 {-pady 8}}
  {laB12 v_2 T 1 1 {-st e} {-t "Type:"}}
  {cbxTyp laB12 L 1 1 {-st w -padx 5 -cw 3} {-tvar adsh__Typ -width 10 -values {MENU EVENT COMMAND} -state readonly}}
  {laB52 laB12 T 1 1 {-st en -rw 1} {-t "Contents:"}}
  {fraComm laB52 L 1 1 {-st nswe -padx 5} {}}
  {texComm - - 1 1 {pack -side left -expand 1 -fill both -in $winf.fraComm} {-h 6 -w 50 -wrap word -tabnext $winf.chbActive}}
  {sbvComm texComm L 1 1 {pack -in $winf.fraComm}}
  {laB53 laB52 T 1 1 {-st en -rw 1} {-t "Description:"}}
  {fraDesc laB53 L 1 1 {-st nswe -padx 5} {}}
  {texDesc - - 1 1 {pack -side left -expand 1 -fill both -in $winf.fraDesc} {-h 8 -w 50 -state disabled -wrap word}}
  {sbvDesc texDesc L 1 1 {pack -in $winf.fraDesc}}
  {v_3 laB53 T 1 2}
  {laBSort v_3 T 1 1 {} {-t " Options " $fontbold}}
  {frAOpt laBSort L 1 1 {-st nsew}}
  {chbActive - - 1 1 {-in $winf.frAOpt} {-t " Active " -var adsh__active}}
  {chbAuto chbActive L 1 1 {-in $winf.frAOpt} {-t " AutoStart " -var adsh__auto}}
  {chbSort chbAuto L 1 1 {-in $winf.frAOpt} {-t " Sorted list " -var adsh__sort -com adsh__sortToggle}}
  {v_4 laBSort T 1 2 {-rsz 10} {}}
  {fra v_4 T 1 2 {-st e -padx 5} {-relief groove -borderwidth 1}}
  {fra.butInsert - - 1 1 {-st w} {-t "Add" -com adsh__addItem}}
  {fra.butChange fra.butInsert L 1 1 {-st w} {-t "Change" -com adsh__changeItem}}
  {fra.butDelete fra.butChange L 1 1 {-st w} {-t "Delete" -com adsh__deleteItem}}
  {fra.h_ fra.butDelete L 1 1 {-padx 10}}
  {fra.butTest fra.h_ L 1 1 {-st w} {-t "Test" -com adsh__testItem}}
  {fraTr laB1 L 14 3 {-st nsew}}
  {tre1 - - 1 1 {pack -side left -in $winf.fraTr -expand 1  -fill both} {-columns "ID A S"}}
  {sbv tre1 L 1 1 {pack -in $winf.fraTr}}
  {v__u fra T 1 6}
  {seh v__u T 1 6}
  {laBMess seh T 1 2 {} "-foreground white -font \"-weight bold\""}
  {laBh_1 laBMess L 1 1 {-cw 1}}
  {fra2 laBh_1 L}
  {fra2.butApply - - 1 1 {} {-t "Apply" -com "adsh__doApply"}}
  {fra2.butOK fra2.butApply L 1 1 {} {-t "Save" -com "adsh__doSaveExit"}}
  {fra2.butCancel fra2.butOK L 1 1 {} {-t "Exit" -com "exit"}}
}
$winf.texComm replace 1.0 end "Testing..."
pdlg showModal $win -focus $winf.entOrig -geometry +100+100 -decor 1
destroy $win

#======================================================

  set login "mylogin"
  apave::APaveInput create dlg
    set res [dlg input ques "My site" [list \
      entLogin {{Login......}} "{$::login}" \
      entPassw {{Password...} {} {-show *}} {} \
    ] -weight bold -head "\n Enter to register here:"]
  puts $res
  dlg destroy

#======================================================

  set win .win2
  set fil0 "Some-file-name-0"
  set fil1 "Some-file-name-1"
  pdlg makeWindow $win.fra "Find and Replace"
  pdlg window $win.fra {
{fraM - - - - {pack -fill x}}
{fra2 - - - - {pack -fill x}}
{fra3 - - - - {pack -fill x} {-relief raised}}
{fraM.lab0 - - - - {pack -pady 10} 
  {-t {  Demo for $\::fil0 and $\::fil1 values (and $ as dollar)  }}}
{fraM.labent1 - - - - {pack -side left} {-t "Enter file name:"}}
{fraM.Ent1 - - - - {pack -side right -expand 1 -fill x} {-tvar ::fil0}}
{fra2.v_0 - - - - {pack -pady 3}}
{fra2.labent1 - - - - {pack -side left} {-t "Choose file:"}}
{fra2.fil1 - - - - {pack -side right -expand 1 -fill x}
{-tvar ::fil1 -title {Pick a file}}}
{fra3.but - - - - {pack -padx 4 -pady 4 -side right} {-t Close -comm exit}}
}
  set res [pdlg showModal $win -focus [pdlg Ent1]]
  puts $res
  pdlg destroy

  exit
