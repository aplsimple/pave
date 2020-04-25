# Last changes:


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
