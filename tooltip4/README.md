It's a Tcl/Tk tooltip widget inspired by:

[https://wiki.tcl-lang.org/page/balloon+help](https://wiki.tcl-lang.org/page/balloon+help)

The original code has been modified to make the tooltip:

  * be faded/destroyed after an interval defined by a caller
  * be enabled/disabled for all or specific widgets
  * be displayed at the screen's edges
  * be displayed with given opacity
  * be displayed as a stand-alone balloon message at given coordinates
  * have configure/cget etc. wrapped in Tcl ensemble for convenience

Below are several pictures just to glance at the *tooltip4*.

*Bold welcome*. The tooltip's font is configured to be "-weight bold -size 11".

 <img src="https://aplsimple.github.io/en/tcl/tooltip4/files/tt1.png" class="media" alt="">

*More standard*.  The tooltip's font is configured to be more standard.

 <img src="https://aplsimple.github.io/en/tcl/tooltip4/files/tt2.png" class="media" alt="">

*Label of danger*. The labels are also tooltipped. This one is configured to be an alert.

 <img src="https://aplsimple.github.io/en/tcl/tooltip4/files/tt3.png" class="media" alt="">

*Button's tip*. This button has its own tooltip, being a caller of a balloon at that.

 <img src="https://aplsimple.github.io/en/tcl/tooltip4/files/tt4.png" class="media" alt="">

*Balloon*. The balloon appears at the top right corner. After a while it disappears.

 <img src="https://aplsimple.github.io/en/tcl/tooltip4/files/tt5.png" class="media" alt="">

## Usage

The *tooltip4* usage is rather straightforward. Firstly we need *package require*:

      lappend auto_path "dir_of_tooltip4"
      package require tooltip4

Then we set tooltips with `::tooltip4::tooltip` command for each appropriate widget:

      ::tooltip4::tooltip widgetpath text ?-option value?
      # or this way:
      ::tooltip4 tooltip widgetpath text ?-option value?

For example, having a button *.win.but1*, we can set its tooltip this way:

      ::tooltip4 tooltip .win.but1 "It's a tooltip.\n2nd line of it.\n3rd."

To get all or specific settings *tooltip4* settings:

      ::tooltip4::cget
      ::tooltip4::cget -option ?-option?
      # or this way:
      ::tooltip4 cget
      ::tooltip4 cget -option ?-option?

To set some options:

      ::tooltip4::configure -option value ?-option value?
      # or this way:
      ::tooltip4 config -option value ?-option value?

**Note**: the options set with `configure` command are *global*, i.e. active for all tooltips.
The options set with `tooltip` command are *local*, i.e. active for the specific tooltip.

To make all (or specific) tooltips use the global settings:

      ::tooltip4::update ?widgetpath?

To disable all tooltips:

      ::tooltip4::configure -on false

To disable some specific tooltip:

      ::tooltip4::tooltip widgetpath ""
      # or this way:
      ::tooltip4::tooltip widgetpath "old tooltip" -on false

To hide some specific (suspended) tooltip forcedly:

      ::tooltip4::hide widgetpath

When you click on a widget with tooltip being displayed, the tooltip is hidden. It is the default behavior of *tooltip4*, but sometimes you need to re-display the hidden tooltip. If the widget is a button, you can include the following command in `-command` of the button:

      ::tooltip4::repaint widgetpath

## Balloon

The *normal* tooltip has no `-geometry` option because it's calculated by *tooltip4*.

So, with `-geometry` option you get a balloon message unrelated to any visible widget (it's made on the toplevel window). The `-geometry` option has +X+Y form where X and Y are coordinates of the balloon.

For example:

      ::tooltip4::tooltip .win "It's a balloon at +1+100 (+X+Y) coordinates" \
        -geometry +1+100 -font {-weight bold -size 12} \
        -alpha 0.8 -fg white -bg black -per10 3000 -pause 1500 -fade 1500

The `-pause` and `-fade` options make the balloon fade at appearing and disappearing. The `-per10` option defines the balloon's duration: the more the longer.

The `-geometry` value can include `W` and `H` *wildcards* meaning the width and the height of the balloon. This may be useful when you need to show a balloon at a window's edge and should use the balloon's dimensions which are available only after its creation. The X and Y coordinates are calculated by *tooltip4* as normal expressions. Of course, they should not include the "+" divider, but this restriction (if any) is easily overcome.

For example:

      lassign [split [winfo geometry .win] x+] w h x y
      set geom "+([expr {$w+$x}]-W-4)+$y"
      set text "The balloon at the right edge of the window"
      ::tooltip4 too .win $text -geometry $geom -pause 2000 -fade 2000

As seen in the above examples, the *tooltip4* can be used as Tcl ensemble, so that the commands may be shortened.

## Options

Below are listed the *tooltip4* options that are set with `tooltip` and `configure` and got with `cget`:

 **-on** - switches all tooltips on/off
 **-force** - if true, forces the display by 'tooltip' command
 **-per10** - a pause per each 10 characters of the tooltip (in millisec.); "0" means "eternal"
 **-fade** - a time of fading (in millisec.)
 **-pause** - a pause before displaying tooltips (in millisec.)
 **-alpha** - an opacity (from 0.0 to 1.0)
 **-fg** - foreground of tooltips
 **-bg** - background of tooltips
 **-bd** - borderwidth of tooltips
 **-font** - font attributes
 **-padx** - x-padding for text
 **-pady** - y-padding for text
 **-padding** - padding for pack
 **-geometry** - geometry (+X+Y) of a balloon message

## Links


  * [Reference](https://aplsimple.github.io/en/tcl/tooltip4/tooltip4.html)

  * [Source](https://chiselapp.com/user/aplsimple/repository/tooltip4/download) (tooltip4.zip)

You can test the *tooltip4* with *test2_pave.tcl* of the *apave* package available at:

  * [apave package](https://chiselapp.com/user/aplsimple/repository/pave/download) (pave.zip)

Note that [tooltip4](https://chiselapp.com/user/aplsimple/repository/tooltip4/download) is still disposed to updating, e.g. for now it doesn't provide the menu item tooltip as the tooltip of tklib does.
