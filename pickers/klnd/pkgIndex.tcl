
package ifneeded ::apave::klnd 0.1 [list source [file join $dir klnd.tcl]]

# A short intro (for Ruff! docs generator:)

namespace eval ::apave {}
namespace eval ::apave::klnd {
  set _ruff_preamble {

  The *::apave::klnd* namespace provides a calendar widget for apave package.

  To directly call the widget, use the following command:

    source [file join $::apave::apaveDir pickers klnd klnd.tcl]
    # or: package require apave::klnd
    apave::klnd::calendar ?-option value?

  where *option* may be:

    -value - sets an input date (if omitted, the current system date)
    -parent - sets a parent window's path to center the calendar widget
    -title - sets the calendar widget's title
    -dateformat - sets the input/output date format (%D by default)
    -weekday - sets a first week day: %w for Sunday, %u for Monday (default)

  If the *-parent* option is omitted, the calendar widget is opened under the mouse pointer. If the *-parent* option is set, the calendar widget is centered in the parent window.

  An example of using the widget for apave layout:

  {dat1 labBdat1 L 1 9 {} {-tvar t::dat1 -title {Pick a date} -dateformat %Y.%m.%d -parent .win}}

  The calendar widget provides the hotkeys Left / Right / Up / Down / F3 / Ctrl(Alt)+Left(Right) to navigate through days/months/years.

  The Enter / Space keys or Double-Click are used to pick a date.
  }
}
