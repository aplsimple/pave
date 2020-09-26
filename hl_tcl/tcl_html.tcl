#! /usr/bin/env tclsh
# ________________________ highlight tcl in html ________________________ #
#
# Highlights Tcl code snippets in html files.
#
# Runs from CLI as follows:
#   tclsh tcl_html.tcl file1.html [file2.html [...]]
#
# Scripted by Alex Plotnikov.
# License: MIT.
# _______________________________________________________________________ #

source [file join [file dirname [info script]] hl_tcl_html.tcl]
foreach fhtml $::argv {
  ::hl_tcl_html::highlight $fhtml {<code class="tcl">} {</code>}
}
