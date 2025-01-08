# Last changes:


Version `4.4.11 (4 Jan'25)`

  - NEW   : -onevent attribute (list of event+commands pairs)
  - NEW   : %w wildcard in tool bar commands
  - CHANGE: attributes of status bar labels - for values only
  - CHANGE: icon for calender's today
  - CHANGE: package bartabs 1.6.10


Version `4.4.10 (7 Sep'24)`

  - CHANGE: method fillGutter: more simple in use: less "after" (thanks to George)


Version `4.4.9 (7 Aug'24)`

  - NEW   : method bindGutter makes bindings for a text and its gutter


Version `4.4.8 (24 Jul'24)`

  - NEW   : ent & cbx widgets for toolbar
  - CHANGE: apave::splitGeometry: handle X,Y coordinates as is; neg coordinates flag
  - CHANGE: tiny clearance


Version `4.4.6 (29 Jun'24)`

  - NEW   : Enter key for treeview = Return key
  - CHANGE: hl_tcl 1.1.4


Version `4.4.5 (3 May'24)`

  - NEW   : allow uppercased frame for nbk tab (resulting in method of same name)
  - NEW   : allow additional attributes for toolbar items, e.g. -font
  - NEW   : proc DefaultCS: gets default color scheme
  - NEW   : proc InvertBg: inverted color
  - NEW   : method onTop: -topmost attribute
  - CHANGE: "23: Dusk" color scheme be close to Tk 8.7+ dark palette
  - CHANGE: `-takefocus 0` as default for some widgets


Version `4.4.4 (24 Apr'24)`

  - BUGFIX: mistaken "split $centerme", replaced by apave::splitGeometry
  - NEW   : namespace export: textsplit, focusByForce & Option's
  - CHANGE: tk_optionCascade: reverted to v4.4.1


Version `4.4.3 (22 Apr'24)`

  - NEW   : `-waitme` option of showModal: wait var/idle/time before `deiconify`
  - NEW   : namespace export: obj openDoc readTextFile writeTextFile undoIn undoOut
  - NEW   : checkGeometry: check window's geometry
  - CHANGE: focusApp: restore widget's focus as well
  - CHANGE: pavedPath: Modalwin variable
  - CHANGE: tk_optionCascade: `after idle optionCascade_add` for better performance
  - CHANGE: klnd: Windows' issues & clearance
  - CHANGE: umbrella icon


Version `4.4.1 (3 Apr'24)`

  - NEW   : apave.tcl: batch of procs moved from alited project
  - NEW   : `-focus` option of showModal: if "Tab", try to focus 1st widget Tabbed
  - NEW   : calendars: -weeks option shows (1, 2) or hides (0) week numbers
  - NEW   : focusApp: restore app's focused toplevel after focusing app
  - CHANGE: refactoring code
  - CHANGE: hl_tcl 1.1.3, bartabs 1.6.9, baltip 1.6.2


Version `4.3.10 (28 Feb'24)`

  - BUGFIX: *-initialdir* of file chooser: fails at dir with spaces


Version `4.3.9 (7 Feb'24)`

  - NEW   : proc blinkWidgetImage to flash icons
  - NEW   : method askForSave to set/get flag "ask for saving"


Version `4.3.8 (18 Jan'24)`

  - BUGFIX: edit text dialog: asking "Save changes" fails at 2nd run
  - NEW   : %w wildcard (current window) in *-onclose* option
  - CHANGE: *-onclose* command added to dialog buttons' handlers
  - CHANGE: more rigorous checking *-onclose* and *-ch* used together ("string match destroy")


Version `4.3.6 (3 Jan'24)`

  - BUGFIX: *plastic* ttk theme + *-2. Default* CS => error (-fg / -bg / $Fgbut / $Bgbut)
  - CHANGE: -highlightcolor of "." for *classic* ttk theme


Version `4.3.5 (27 Dec'23)`

  - NEW   : Ctrl+B / Ctrl+E to move the cursor to real beginning / end of wrapped line
  - CHANGE: method themeWindow: *-arrowcolor* option (for "Tk 9.0 + dark CS" case)
  - CHANGE: method AddButtonIcon: correct `res` call for *-com integer* option


Version `4.3.4 (20 Dec'23)`

  - CHANGE: *-undeline* options for menu and notebook (Tk 9.0 fixed)


Version `4.3.3 (13 Dec'23)`

  - NEW   : method chooserPath: path to chooser's entry/label
  - CHANGE: method Replace_chooser: restored *-validatecommand*
  - CHANGE: proc splitGeometry: check result for x, y


Version `4.3.2 (5 Dec'23)`

  - BUGFIX: Tcl 9.0 bug making Alt+key unusable (*-underline* option of menubar items)


Version `4.3.1 (1 Dec'23)`

  - CHANGE: checking "namespace exists ::tablelist:"


Version `4.3.0 (30 Nov'23)`

  - NEW   : way to Tcl 9.0
  - CHANGE: geometry stuff checked


Version `4.2.2 (22 Nov'23)`

  - NEW   : baltip package's option *-eternal*
  - NEW   : date picker: OK button picks selected day, F3 key goes to current day
  - CHANGE: date pickers cleared a little


Version `4.2.1 (15 Nov'23)`

  - BUGFIX: env(TCLLIBPATH) cleared wrongly in apavebase.tcl
  - BUGFIX: highlighting a word at beginning of line (e.g. "namespace")
  - CHANGE: color picker


Version `4.2.0 (8 Nov'23)`

  - BUGFIX: for klnd & klnd2: disable clicks on empty cells
  - NEW   : de.msg, es.msg for pickers
  - NEW   : ::tk::dialog::color::GetOptions
  - NEW   : for clr: -validatecommand option
  - NEW   : for klnd: -popup option, wildcards %d,%m,%y in -command option
  - NEW   : combine showModal's options: "-centerme .win -geometry WxH" (without +X+Y)
  - CHANGE: validateColorChoice method: "entry selection clear"
  - CHANGE: "Close" button of klnd localized
  - CHANGE: "::apave::mainWindowOfApp ." initializes "main window of app" setting
  - CHANGE: "CleanUps $win" after closing modal/waited windows
  - CHANGE: unnecessary decorative comments removed


Version `4.1.8 (25 Oct'23)`

  - CHANGE: chooserGeomVars method: sets/gets variables for file/dir choosers' geometry
  - CHANGE: AuxSetChooserGeometry method: default geometry of file/dir choosers


Version `4.1.7 (2 Oct'23)`

  - CHANGE: the -container option of showModal method is changed to -transient
  - CHANGE: "-root $w" and "-parent $w" are the same as (recommended) "-centerme $w"
  - CHANGE: APaveDialog's dialogues delegate the -transient option to showModal


Version `4.1.6 (27 Sep'23)`

  - NEW   : mainWindowOfApp method
  - CHANGE: hl_tcl 1.0.6, baltip 1.5.4


Version `4.1.5 (14 Sep'23)`

  - BUGFIX: setting geom variable in AuxSetChooserGeometry method (potential bug)
  - NEW   : "-container $win" option for showModal method


Version `4.1.4 (7 Sep'23)`

  - DELETE: "grab release $wgr" in showWindow method


Version `4.1.3 (6 Sep'23)`

  - CHANGE: method waitWinVar


Version `4.1.2 (30 Aug'23)`

  - BUGFIX: display Tk core file/dir choosers in KDE & Fluxbox WM
  - CHANGE: default -decor option
  - NEW   : method waitWinVar


Version `4.1.1 (21 Jun'23)`

  - NEW   : csSet method: colors can be passed in args as -clrtitf "color" etc...


Version `4.1.0 (26 Apr'23)`

  - NEW   : klnd::clearup - clearance for klnd data
  - DELETE: dlgPath & Pdg methods
  - CHANGE: get rid of arrays or their vars (Moveall instead of _pav(moveall) etc.)
  - CHANGE: untouchWidgets: if 1st item of *args* is "clear", clears items by glob patterns
  - CHANGE: hl_tcl 1.0.5


Version `4.0.8 (19 Apr'23)`

  - NEW   : initLinkFont method allows setting -foreground/-background


Version `4.0.7 (14 Apr'23)`

  - NEW   : -labelwidget attribute (of lfr/lfR) can be a path method
  - CHANGE: findInText method: 'dobell' argument
  - CHANGE: hl_tcl 1.0.4


Version `4.0.6 (5 Apr'23)`

  - BUGFIX: spinbox' tips (not for blank "from..to")
  - NEW   : -minsize option for dialogues
  - NEW   : msgcatDialogs proc to localize apave's messages
  - CHANGE: check for {#commented item of widlist}
  - CHANGE: indentation at inserting braces
  - CHANGE: hl_tcl 1.0.3, bartabs 1.6.7


Version `4.0.4 (25 Mar'23)`

  - CHANGE: "fillGutter $txt" to clear data of $txt
  - CHANGE: -decor option of showModal initialized properly
  - CHANGE: ButtonTip of klnd2.tcl: provide %D wildcard as specified (%Y/%m/%d)
  - CHANGE: hl_tcl 1.0.2, bartabs 1.6.6


Version `4.0.3 (23 Mar'23)`

  - CHANGE: -decor option of showModal initialized properly
  - CHANGE: ButtonTip of klnd2.tcl: provide %D wildcard as specified (%Y/%m/%d)
  - CHANGE: hl_tcl 1.0.1


Version `4.0.2 (15 Mar'23)`

  - CHANGE: "file" icon
  - CHANGE: "Close" icons instead "Exit", in dialogues
  - CHANGE: DarkBrown CS: bg1 & selection colors
  - CHANGE: hl_tcl 1.0.0


Version `4.0.1 (8 Mar'23)`

  - NEW   : -com of "but" (button) can be integer (a returned result)
  - NEW   : -initialdir of "fil" and "fis" (file chooser) can be "-$path" to return a rootname only
  - CHANGE: dlgPath methods
  - CHANGE: cursor at entry's end after choosing from choosers
  - CHANGE: -rotext of text dialogues to disable "\\n -> \n" mapping
  - CHANGE: some CS's tip colors
  - CHANGE: bartabs 1.6.5


Version `4.0.0 (1 Mar'23)`

  - BUGFIX: closing non-modal windows in arbitrary order
  - BUGFIX: input method: text fields containing "\", "{", "}"
  - NEW   : showModal: "-waitvar 1" option to force "tkwait variable" at "-modal 0"
  - NEW   : showWindow: "waitvar" argument to force "tkwait variable" at "-modal 0"
  - NEW   : -onclose option of dialogues: may be "destroy" (useful for non-modals)
  - NEW   : handler of dialogue's buttons may be "destroy" (useful for non-modals)
  - NEW   : input method: radiobutton names may be "Names"
  - NEW   : input method: -comOK option (OK button's command)
  - NEW   : OK dialogue may be "-modal 0" (nothing to choose, only viewing)
  - NEW   : apave::traceRemove proc: cancel tracing of a variable
  - NEW   : apave::InsertChar proc: insert characters into a text at cursor's position
  - NEW   : dlgPath method: get dialogues' window path
  - NEW   : thDark method: check if a theme is dark/light/neutral
  - NEW   : BWidget::place ----> apave::place, used in initWM
  - CHANGE: winfo vrootwidth / vrootheight
  - CHANGE: APave => APaveBase, apave.tcl => apavebase.tcl, APaveInput => APave, apaveinput.tcl => apave.tcl
  - CHANGE: ::islinux => ::isunix
  - CHANGE: DarkBrown CS
  - CHANGE: klnd: -width option to change days' width; -locale initialized
  - CHANGE: hl_tcl 0.9.49, baltip 1.5.2, bartabs 1.6.4


Version `3.7.0 (8 Feb'23)`

  - NEW   : apave::InitBaltip, -isbaltip option of apave::initWM (to dismiss baltip)
  - NEW   : apave::SRCDIR to hold apave's source directory
  - NEW   : -centerme option can be a caller's geometry (WxH+X+Y)
  - NEW   : misc method's buttons argument: "result" can be or a command to get the result
  - NEW   : Query method: 5 buttons added to "buttons" (possible total 7)
  - CHANGE: LightBrown & DarkBrown moved in the CS list
  - CHANGE: hl_tcl 0.9.48


Version `3.6.7 (29 Jan'23)`

  - NEW   : gutterContents method: gets a gutter's current contents
  - CHANGE: lightbrown theme & LightBrown CS instead of old ones


Version `3.6.6 (27 Jan'23)`

  - BUGFIX: -tabnext option: when it's set as "[command]"
  - NEW   : highlight_matches_real: for real highlighting words (esp. for Windows)
  - CHANGE: Radiance CS


Version `3.6.5 (25 Jan'23)`

  - BUGFIX: setting "theme" variable in InitTheme
  - NEW   : handle plastik, radiance and darkbrown themes in InitTheme
  - NEW   : -encoding and -translation options of readTextFile / writeTextFile
  - DELETE: all shadowing stuff (shadowAllowed etc.)
  - CHANGE: in text dialogues: popup's "Save and Exit" and Ctrl+W both return "1"
  - CHANGE: CS: Radiance & DarkBrown instead of Yellowstone & Dark3
  - CHANGE: bartabs 1.6.3, hl_tcl 0.9.46


Version `3.6.4 (18 Jan'23)`

  - BUGFIX: Dark* themes: corrected "actfg" color
  - BUGFIX: initialize basic CS of tuned CS
  - BUGFIX: Replace_chooser: horizontal scrollbar for "ftx" widget
  - NEW   : -tabnext option: may be a call of procedure
  - NEW   : Replace_chooser: grid/pack options for expanding "mega-widgets"
  - CHANGE: initWM: "default" theme by default, instead of "clam"
  - CHANGE: little clearance
  - CHANGE: bartabs 1.6.2


Version `3.6.3 (4 Jan'23)`

  - NEW   : TMenubutton arrow: disabled color
  - CHANGE: hl_tcl 0.9.45


Version `3.6.2 (28 Dec'22)`

  - DELETE: tests directory (separated into apave_tests repo)


Version `3.6.1 (14 Dec'22)`

  - NEW   : -tabnext option can be 2 item list, 2nd (omittable) is "widget" for Shift+Tab
  - NEW   : focus fg/bg of TButton
  - NEW   : apave::FGMAIN2 / BGMAIN2 for field colors
  - NEW   : TreeNoHL style for treeview not highlighted
  - CHANGE: Treeview colors: selected focus / not focus


Version `3.6.0 (7 Dec'22)`

  - BUGFIX: (esp. for Windows) fire entry's invalidation after choice from choosers
  - BUGFIX: erroneous combination CS=-1 & Tint!=0
  - BUGFIX: in Windows: shimmering white in embedded calendar (klnd2)
  - BUGFIX: APave object: omit some commands of popup menu for text widget
  - BUGFIX: "+" as L/T neighbor in widget list didn't work for mega-widgets (dir,ftx...)
  - BUGFIX: empty widget list (lwidgets) in Window method
  - BUGFIX: removeOptions method to remove all instances of options
  - NEW   : touchWidgets method
  - NEW   : FG FG2 BG BG2 tags among link tags (defining colors)
  - NEW   : apave::isKDE, apave::repaintWindow
  - NEW   : -parent option of chooser method
  - NEW   : btT type of toolbuttons (non-ttk)
  - NEW   : apave::ttkToolbutton for ttk Toolbutton widgets: btt brt blt
  - NEW   : -cs argument for initWM, to initialize CS before any GUI visible
  - NEW   : apave::defaultAttrs sets a user defined widget (demoed by test2_pave.tcl)
  - NEW   : rootModalWindow to get modal parent window
  - NEW   : deiconify / withdraw / iconifyOption procs
  - NEW   : getShowOption / setShowOption for default options of showModal
  - NEW   : initStyle & clearing code
  - CHANGE: untouchWidgets: additional attributes
  - CHANGE: themeWindow: scrollbars active/disabled
  - CHANGE: remove the old loaded aw* themes before loading the new ones
  - CHANGE: frame instead of ttk::frame for paving $win.fra => no shimmering of bg, when dark themes are used
  - CHANGE: themeWindow: colors of scrollbar at hovering
  - CHANGE: ttk::combobox is included in navigation by Return/Enter key
  - CHANGE: color chooser got -geometry option to be placed under mouse pointer or entry
  - CHANGE: colorWindow args
  - CHANGE: hovering color for buttons = mild magenta
  - CHANGE: check for using csToned before csSet
  - CHANGE: iconA & AddButtonIcon: -compound option (esp. for toolbuttons named by icons)
  - CHANGE: at Windows' themes: -focusfill for TCombobox
  - CHANGE: less sizes of calendars (klnd & klnd2)
  - CHANGE: highlight days in klnd & klnd2 (esp. for Windows)
  - CHANGE: centering & showing windows, with new procs
  - CHANGE: -resizable option may be boolean
  - CHANGE: highlightbackground for main toolbar buttons + overrelief (esp. for Windows)
  - CHANGE: test2_pave.tcl
  - CHANGE: hl_tcl 0.9.44, bartabs 1.6.0


Version `3.5.9 (25 Oct'22)`

  - NEW   : "-buttons" option for "input" method
  - NEW   : commands for buttons of dialogues (along with old "returned result")
  - CHANGE: -resizable & -checkgeometry options and other geometry things
  - CHANGE: AzureLight CS (selection bg)
  - CHANGE: hl_tcl 0.9.43


Version `3.5.8 (23 Oct'22)`

  - NEW   : apave::eventOnText - cut & copy for multiple selections
  - NEW   : Query method: -stay option
  - CHANGE: Query method: "wm geometry" instead of "winfo ..."


Version `3.5.7 (19 Oct'22)`

  - CHANGE: *input* method: *-values* option added for all default widgets
  - CHANGE: ::apave::autoexec got *ext* argument, for Windows
  - CHANGE: baltip 1.5.1


Version `3.5.6 (5 Oct'22)`

  - BUGFIX: dir chooser: -initialdir option need no quoting


Version `3.5.5 (21 Sep'22)`

  - NEW   : apave::undoIn / apave::undoOut to frame undo / redo block
  - CHANGE: test2_pave.tcl
  - CHANGE: baltip 1.4.1, bartabs 1.5.8


Version `3.5.4 (31 Aug'22)`

  - NEW   : chooserGeomVars method to restore a full geometry of dir/file choosers (Linux)
            e.g. used in alited editor


Version `3.5.3 (25 Aug'22)`

  - CHANGE: text widget's attributes (-exportselection, -inactiveselectbackground)
  - CHANGE: UpdateSelectAttrs not called for text widget


Version `3.5.2 (15 Aug'22)`

  - NEW   : apave::_CS_(HUE) to hold a current tint of CS
  - CHANGE: CS: SunValleyDeep


Version `3.5.1 (10 Aug'22)`

  - BUGFIX: colorWindow for "after idle/ms" item of widget list
  - BUGFIX: font chooser (Linux): color of selection
  - BUGFIX: after calling and theming choosers (linux), combobox's colors affected
  - NEW   : apave::autoexec imitates Tcl's auto_execok
  - NEW   : apave::lsearchFile to search normalized file names in lists
  - NEW   : apave::InitAwThemesPath to set awthemes' path
  - NEW   : bind for transpops package if any (to hide its message by Control-Alt-0)
  - NEW   : -clearcom option for entry-like widgets (adds "Clear" to popup menu)
  - NEW   : -help option for dialogues (to create "Help" button)
  - NEW   : dlgPath method & proc to get apave dialogue's path
  - CHANGE: value of combobox' variable in input dialogue
  - CHANGE: sframe.tcl refactored: checking mouse pointer in text, listbox etc.
  - CHANGE: res method: if *win* argument is {}, it's set as current dialogue's path
  - CHANGE: CS: Quiverly modified to quiver a little less
  - CHANGE: CS: AzureLight, AzureDark, SunValleyLight
  - CHANGE: baltip 1.4.0, hl_tcl 0.9.42


Version `3.4.18 (3 Jul'22)`

  - NEW   : menuTips method and -indexedtips to set tips for menu & opc items
  - NEW   : -titleHELP option for 'input' dialogue (its 'result value' is a command)
  - CHANGE: CS: SunValleyDark from old Dracula, new SunValleyDeep from old SunValleyDark
            - best fit to sun-valley-dark theme, meaning two (lighter/darker) CS for it


Version `3.4.16 (23 Jun'22)`

  - NEW   : widget names for "input" can be uppercased (or include -method option)
  - CHANGE: VarName method renamed to varName for public access
  - CHANGE: makePopup checks also for -state = disabled
  - CHANGE: remove accompanying files of baltip & bartabs packages
  - CHANGE: bartabs package


Version `3.4.14 (18 Jun'22)`

  - BUGFIX: (avoiding bugs) check "source baltip.tcl"
  - BUGFIX: (avoiding bugs) catch "configure splash widgets"
  - NEW   : {after idle} or {after ms} can be 1st item of widget list
  - CHANGE: up to 16 levels for [info level] in ::apave::logMessage
  - CHANGE: up to 5 tabs in -tab2 option
  - CHANGE: test2_pave.tcl: About/Acknowledgements


Version `3.4.12 (8 Jun'22)`

  - BUGFIX: (avoiding bugs) apave::setTextBinds: bindToEvent instead of "bind"
  - BUGFIX: (avoiding bugs) my set_highlight_matches: check for existing text
  - NEW   : apave::iconImage: "doit" argument to force the initialization
  - CHANGE: Control-a/A to select all of text
  - CHANGE: obbit_1.test
  - CHANGE: baltip, bartabs packages


Version `3.4.11 (20 May'22)`

  - CHANGE: bartabs package


Version `3.4.10 (14 May'22)`

  - CHANGE: duplicate a current line (by Ctrl+D) "properly", if it is last in the text
  - CHANGE: get file/dir chooser geometry from 2nd chooser, if no geometry for current one


Version `3.4.9 (30 Apr'22)`

  - BUGFIX: line numbers in the gutter are updated only for mapped texts
  - CHANGE: test2_pave.tcl
  - CHANGE: klnd package


Version `3.4.8 (8 Mar'22)`

  - BUGFIX: klnd2.tcl - leading spaces at comparing months & clearance
  - BUGFIX: uk.msg instead of ua.msg
  - NEW   : frames scrolled by the mouse wheel (in Linux)
  - NEW   : apave::InitTheme
  - NEW   : apave::MODALWINDOW is a window name of last called showModal
  - NEW   : basicSmallFont to set/get the small font
  - CHANGE: klnd: bg of frames & buttons
  - CHANGE: tiny-ups with lsearch & switch
  - CHANGE: klnd.tcl - buttons' width in Windows = in Linux
  - CHANGE: test2_pave.tcl
  - CHANGE: hl_tcl package


Version `3.4.7 (26 Jan'22)`

  - NEW   : -popup attribute (command for right-click)
  - NEW   : <Home>, <End> bindings for listbox & treeview
  - NEW   : -tags option for readonly text widget & dialogue
  - NEW   : -tab2 option for dialogue
  - NEW   : 'selection clear' at button/key pressing treeview & listbox
  - NEW   : 'padchar' argument of setTextIndent
  - NEW   : -debug attribute to show a widget's info while executing paveWindow
  - CHANGE: csDarkEdit converted to csDark
  - CHANGE: at Enter on a comment (# ) checking for upper & lower lines
  - CHANGE: at Enter on a left brace checking for indentation of lower line
  - CHANGE: -com attribute to fire a spinbox' command at pressing Return/Enter
  - CHANGE: test2_pave.tcl
  - CHANGE: hl_tcl package


Version `3.4.6 (15 Dec'21)`

  - BUGFIX: issues with pressing Enter at "-", "*", "#" starting lines
  - BUGFIX: -initialdir option for file chooser
  - BUGFIX: default/classic/alt theme & dark CS: selected check/radio buttons' bg
  - BUGFIX: treeview's ttk::style for CS=-2 (i.e. if no CS)
  - BUGFIX: display redefined Ctrl+Y/D, F3
  - NEW   : unit tree for obbit.tcl, apaveinput.tcl, apavedialog.tcl
  - NEW   : ::apave::writeTextFile option of deleting empty files instead of saving
  - NEW   : ::apave::bindToEvent
  - NEW   : -method option to define a method in apave object
  - NEW   : tooltip for notebook tab
  - NEW   : unit tree for apave.tcl
  - NEW   : calendar: updating for y/m
  - NEW   : calendar: proc for right click (%y, %m, %d, %X, %Y wildcards)
  - NEW   : calendar: list of selected (fg) days
  - NEW   : progress procs (begin, go, end); add it to widgetType method & test2
  - NEW   : daT widget - calendar widget
  - NEW   : ru.msg, ua.msg for klnd
  - NEW   : 'pack -after .a.b.c' may be 'pack -after C', then [my C] used
  - NEW   : using TCLLIBPATH (spec.feature for tclkits)
  - NEW   : tooltip of spinbox (from..to)
  - NEW   : -padx, -pady options for entry fields of choosers
  - NEW   : topmost attribute in showModal depending on a window's ancestors
  - NEW   : cs_Active to set/get flag "no CS changes"
  - CHANGE: sourcing baltip.tcl modified
  - CHANGE: csMainColors includes e_menu colors
  - CHANGE: test0, test1, test2 modified
  - CHANGE: klnd.tcl refactored (unit tree, inits)
  - CHANGE: modified style of TButton, TNotebook.Tab
  - CHANGE: modified CS for: bg of menus, cursor, selection, tips
  - CHANGE: modified CS: Oscuros, MildDarks, rdbende's Darks
  - CHANGE: hl_tcl, baltip, bartabs packages updated


Version `3.4.5 (6 Oct'21)`

  - bugfix: font chooser's returned value (in Windows)
  - comboboxed fiL, fiS, diR, foN, clR types of choosers
  - swi (switch) widget
  - new methods: resetText, precedeWidgetName, paveoptionValue
  - modified methods: displayTaggedText
  - at pressing Enter: "-", "*", "#" duplicated with indentation
  - focused "opc" widget at mouse clicking
  - TButtonWestHL ttk::style
  - AwDark, AwLight color schemes instead of Dark and Celestial
  - Dusk CS above Darcula, to align light and dark "themed" CS
  - themePopup, themeNonThemed to touch a parent popup menu
  - -selectcolor for menus' check/radio
  - modified style of TScrollbar, TProgressbar, TLabelframe
  - bg color of disabled toolbar icons
  - listbox' bg color corrected
  - azure, forest, sun-valley and some other CS modified
  - menu's borderwidth 1 for themes by rdbende
  - create_Fonts run at changing default font size
  - heading style for treeview
  - Shift/Ctrl+Enter in texts corrected
  - text undo/redo separators
  - choosers' options (-initialdir, -initialfile, -defaultextension, -multiple)
  - test2_pave.tcl got "theme" option
  - menu/tool/status bars allow to set "# comment" to comment lines out
  - hl_tcl, bartabs, klnd packages updated


Version `3.4.4 (25 Aug'21)`

  - default colors changed in InitWM
  - "opc" allows -com/-command option
  - background color of entry, spinbox and alike
  - ttk theme + apave's color scheme = love
  - CS revised;  added; got 3rd reserved color
  - colorized color chooser
  - colorWindow in.
  - fonts brought to order
  - log messages
  - -themed option of showModal
  - hl_tcl, baltip packages updated


Version `3.4.1 (4 Aug'21)`

  - scf (scrolled frame) widget
  - chooseDate used independently
  - text's find next corrected
  - HILI (highlighting) bound to a text widget
  - onKeyTextM modified (to cut a text by Return/Enter)
  - getting -topmost option of dialogue corrected
  - modal mode corrected for Linux
  - hl_tcl, bartabs, baltip packages updated


Version `3.3.3 (26 Apr'21)`

  - "-expand 1" option for 'sta'
  - create_FontsType to make apaveFont*Typed* fonts from apaveFont*
  - leadingSpaces
  - initStylesFS to style lab/chb/cbx/rad/but
  - some CS colors mod.
  - LowercaseWidgetName for Toolbar (making its method, to refer its buttons)
  - catch for 'options/attrs' (to get literals instead of errors of variables' subst)


Version `3.3.2 (17 Apr'21)`

  - highlighted string for searching with F3
  - an indenting amended
  - cursor settings modified
  - CS rearranged & renamed
  - active/focus colors for sca/sb*/nbk.tab
  - "-tip" may be used along with "-tooltip"
  - "-after/-before %w" for packing sbv/sbh instead of default setting
  - "-minsize" for showModal/showWindow
  - "-pointer/pointer+x+y" for showModal/showWindow's -geometry
  - "-escape" option for showModal
  - "-wrap word" default for 'tex'
  - -selborderwidth for 'tex' (default 1)
  - -columnoptions for 'tre'
  - for menuBar: 7th arg as 'fillmenu' command
  - TLabelSTD, e.g. for statusbar labels
  - extractOptions, writeTextFile & error procs introduced
  - defaultAttrs instead of setDefaultAttrs, with more options
  - icons for mc-labels
  - "pack/grid propagate" for "pan" if -w and -h set
  - clrpick.tcl updated
  - bartabs, hl_tcl, baltip packages updated
  - BUGFIX: menu's colors restored for themes


Version `3.3.1 (6 Mar'21)`

  - better handling for modal/non-modal windows
  - color hues in.
  - themes rearranged
  - klnd, hl_tcl, baltip packages upd.
  - BUGFIX: remove the tailing " &" in openDoc
  - BUGFIX: -disabledforeground for menu
  - BUGFIX: use uppercased parent

Version `3.3 (14 Feb'21)`

  - color (Tk's modified) and date (new) choosers in 'src/pickers'
  - theming file/dir choosers in Unix
  - checking for screen's edges in ShowModal
  - args for 'toplevel' in makeWindow
  - for apave dialog with text: TkDefaultFont if not editing
  - "font actual" instead of "font configure"
  - hl_tcl & bartabs packages updated
  - BUGFIX (and recommendation): in -lbxname checking "winfo exists"
  - BUGFIX: in input method, checking $res is true (not "1")


Version `3.2.8 (31 Jan'21)`

  - modifying style of scale, scrollbar, combobox
  - modifying menu's font size
  - CS made milder
  - revising popup menus of text widget
  - color of matching bracket is magenta
  - modifying & moving highlight matches procs from ::em to ::apave
  - labelFlashing's -data allows var contents along with var name
  - fillGutter can be run to update a gutter, e.g. at switching CS
  - squeezing icons
  - updating hl_tcl, bartabs packages


Version `3.2.7 (17 Jan'21)`

  - "gut" (gutter) widget
  - default "-highlightbackground" for non-ttk
  - eventOnText: for menu items at highlighting
  - CS modified
  - bartabs, hl_tcl updated


Version `3.2.5 (26 Dec'20)`

  - hl_tcl package
  - baltip package
  - borderwidth for text sel
  - indent & font of text widget
  - linked labels (also in text), also with images
  - icon sets: "small", "middle" ("large" to do)


Version `3.1 (12 Sep'20)`

  - bartabs package v1.0
  - 'nbk' attributes: -traverse yes/no, -select tab
  - 'lab' got "-state disabled" attribute
  - "-modal false" option of showModal makes the window non-modal
  - displayText got 'pos' parameter (position of cursor)
  - BUGFIX: text attribute for choosers could not contain spaces


Version `3.0.1 (17 Jul'20)`

  - ::tk::PlaceWindow being helped again


Version `3.0b8 (27 Jun'20)`

  - version bound to e_menu's
  - `chb` value & appearance amended
  - `add` command moved to grid/pack item; old `add` item removed
  - `-toprev` attribute for `but` & `chb` in input dlg
  - `but` in input dlg
  - errors of input dialog are caught and messaged
  - readonly text's `-takefocus` amended
  - `-myown` attribute
  - mass commenting of methods & procs
  - reference docs in Ruff!
  - `Paste` event removes selection in text
  - `-timeout` option for buttons & dialogs
  - `But*` & `Lab*` in dialogs
  - `::apave::obj` instead `themeObj`
  - CS amended a lot
  - fixed issue with `-lbxname` option
  - `spx/spX` included in toolbar
  - changing default font size


Version `2.9b4 (1 Jun'20)`

  - `tcl` sort of widget (to make Tcl code in widget list)
  - -msgLab option of input dialog
  - \n and \t  for `tex`
  - tkwait visibility added
  - ::tk::PlaceWindow supported
  - a bit of new CS
  - renaming CS methods
  - `setFocus` finds -tabnext widget by glob match, e.g. OK for a button
  - `setDefaultAttrs` to set default attributes
  - `pobj paveWindow` is preferred to the old `pobj window` (kept on for
    compatibility)
  - `UpdateSelectAttrs` allows to change selection atrributes in run-time;
    well fit to set "!fosus color" of -selectfg/bg for some non-ttk widgets
  - sequence of the previous:
    initial selectfg/bg set to "!fosus color" for lbx/tbl/flb/spX/cbx/fco
  - cbx colors amended
  - -ALL option for lbx/tbl/flb: if true, it returns a list of 3 items -
    index, selection, item list (by default, only selection is returned)
  - `subst` for -array option, to pass a variable value
  - test2_pave.tcl adjusted, for these two changes
  - F2 hotkey added to choosers' entries (fil, dir etc.)
  - "-takefocus 0" as default for choosers' buttons (fil, dir etc.)
  - changed 3 icons (none, color, retry) to work in some Tk
  - coloring of TNotebook.Tab modified


Version `2.8 (24 May'20)`

  - `nbk` widget type for ttk::notebook
  - `pack forget` for layouts
  - blinking by default bg removed
  - popup menus got their coloring with CS
  - `themingPopup` method to solve all popup CS issues
  - `subst vars` allowed in value fields of `input` dialog
  - -activefg/bg for non-ttk buttons
  - statusbar layout corrected (.neighbor allowed, as old neighbor)
  - test2_pave.tcl got icons & new statusbar (the old in comments)


Version `2.7 (22 May'20)`

  - color schemes added
  - cs (color scheme) argument of APave / APaveDialog / APaveInput constructor
  - opc (tk_optionCascade) widget added to APave
  - opc (tk_optionCascade) may be used in too (toolbar) widget
  - opc (tk_optionCascade) widget added to APaveInput ("input" dialog)
  - but (ttk::button) may be used in too (toolbar) widget, with -image
  - fco widget allows -RE (regexp) to filter records
  - tbl (tablelist::tablelist) color-schemed
  - appIcon: -data preferred to -file
  - initPOP: popup menu with Menu key
  - showModal: disables shadowing; removes blinking by default bg; -themed arg.
  - removeOptions: can remove options without value
  - ttk::button style configured
  - -centerme option of dialogs added (centering relative to a caller's window)
  - -focusback option of dialogs added (restoring an old focus of a caller)
  - "edit modified false" placed nearby "edit reset"
  - "label::tooltip" as a button "-text" may be used to show tooltips
  - save/don't save/cancel at exiting editor
  - text selection used by "Find first" of editor's popup menu
  - -a option (additional options) for message labels of non-text dialogs
  - lbx and tex widgets made sizeable vertically in APaveInput
  - configTooltip method to configure fb, bg etc. attributes of tooltips
  - test2_pave.tcl: opc widgets & color schemes added, toolbar, editor etc.
  - test_pavedialog.tcl: opc widget & color schemes added
  - setting 1st widget amended (uppercase names checked)
  - destructors amended
  - BUGFIX: color chooser failed after 1st incorrect input color
  - BUGFIX: editor's "Save" button not shown at "-readonly 0 -rotext var"
  - massive clean-ups


Version `2.6.3 (25 Apr'20)`

  - icons added for buttons, menus, choosers
  - ttk::button, ttk::label configured in apave::initWM
  - symbolic ID of buttons may be passed to misc dialog
  - displayText, displayTaggedText mod.
  - tests/*.tcl modified
  - clean-ups
  - BUGFIX: fixed -initialfile, -initialdir for file/dir choosers
  - BUGFIX: fixed an issue with focusing at mass keypressing (Esc e.g.)


Version `2.5 (18 Apr'20)`

  - text and entry-like widgets (cbx ent fco spx) got their popup menu
  - corrected popup menu for text widget of dialogs
  - method setTextContents to fill contents of disabled text widgets
  - choosers' names can be titled upper-case
  - little clean-up


Version `2.4 (15 Apr'20)`

  - selection attributes for listboxes, to fix a listbox curselection issue
    as hinted by
      Donal K. Fellow (https://stackoverflow.com, the question
      the-tablelist-curselection-goes-at-calling-the-directory-dialog)
      Mark G. Saye (https://wiki.tcl-lang.org/page/listbox+selection)
  - color initialized for colorChooser
  - cleanup a bit
  - CHANGELOG.md added
