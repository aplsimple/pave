package require Tk
 namespace eval date {
    option add *Button.padX 0
    option add *Button.padY 0
    proc choose {} {
        variable month; variable year; variable date
        variable canvas; variable res
        variable day
        set year [clock format [clock seconds] -format "%Y"]
        scan [clock format [clock seconds] -format "%m"] %d month
        scan [clock format [clock seconds] -format "%d"] %d day
        toplevel .chooseDate -bg white
        wm title .chooseDate "Choose Date:"
        frame .chooseDate.1
        entry .chooseDate.1.1 -textvar date::month -width 3 -just center
        button .chooseDate.1.2 -text ^ -command {date::adjust 1 0}
        button .chooseDate.1.3 -text v -command {date::adjust -1 0}
        entry .chooseDate.1.4 -textvar date::year -width 4 -just center
        button .chooseDate.1.5 -text ^ -command {date::adjust 0 1}
        button .chooseDate.1.6 -text v -command {date::adjust 0 -1}
        eval pack [winfo children .chooseDate.1] -side left \
                -fill both
        set canvas [canvas .chooseDate.2 -width 160 -height 160 -bg white]
        frame .chooseDate.3
        entry .chooseDate.3.1 -textvar date::date -width 10
        button .chooseDate.3.2 -text OK -command {set date::res $date::date}
        button .chooseDate.3.3 -text Cancel -command {set date::res {}}
        eval pack [winfo children .chooseDate.3] -side left
        eval pack [winfo children .chooseDate]
        display
        vwait ::date::res
        destroy .chooseDate
        set res
    }
    proc adjust {dmonth dyear} {
        variable month; variable year; variable day
        set year  [expr {$year+$dyear}]
        set month [expr {$month+$dmonth}]
        if {$month>12} {set month 1; incr year}
        if {$month<1} {set month 12; incr year -1}
        if {[numberofdays $month $year]<$day} {
            set day [numberofdays $month $year]
        }
        display
    }
    proc display {} {
        variable month; variable year
        variable date; variable day
        variable canvas
        $canvas delete all
        set x0 20; set x $x0; set y 20
        set dx 20; set dy 20
        set xmax [expr {$x0+$dx*6}]
        foreach i {S M T W T F S} {
            $canvas create text $x $y -text $i -fill blue
            incr x $dx
        }
        scan [clock format [clock scan $month/1/$year] \
                -format %w] %d weekday
        set x [expr {$x0+$weekday*$dx}]
        incr y $dy
        set nmax [numberofdays $month $year]
        for {set d 1} {$d<=$nmax} {incr d} {
            set id [$canvas create text $x $y -text $d -tag day]
            if {$d==$day} {$canvas itemconfig $id -fill red}
            incr x $dx
            if {$x>$xmax} {set x $x0; incr y $dy}
        }
        $canvas bind day <1> {
            set item [%W find withtag current]
            set date::day [%W itemcget $item -text]
            set date::date "$date::month/$date::day/$date::year"
            %W itemconfig day -fill black
            %W itemconfig $item -fill red
        }
        set date "$month/$day/$year"
    }
    proc numberofdays {month year} {
        if {$month==12} {set month 1; incr year}
        clock format [clock scan "[incr month]/1/$year  1 day ago"] \
                -format %d
    }
 } ;# end namespace date

 #------ test and demo code (terminate by closing the main window)
 while 1 {
     set date [date::choose]
     puts $date
 }
