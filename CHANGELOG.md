# Last changes:


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
