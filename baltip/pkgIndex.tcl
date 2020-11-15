package ifneeded baltip 0.6 [list source [file join $dir baltip.tcl]]

namespace eval ::baltip {

  variable _ruff_preamble {
It's a Tcl/Tk tip widget inspired by:

[https://wiki.tcl-lang.org/page/balloon+help](https://wiki.tcl-lang.org/page/balloon+help)

The original code has been modified to make the tip:

  * be faded/destroyed after an interval defined by a caller
  * be enabled/disabled for all or specific widgets
  * be displayed at the screen's edges
  * be displayed with given opacity
  * be displayed as a stand-alone balloon message at given coordinates
  * have configure/cget etc. wrapped in Tcl ensemble for convenience

Below are several pictures just to glance at the *baltip*.

*Bold welcome*. The tip's font is configured to be "-weight bold -size 11".

 <img src="https://aplsimple.github.io/en/tcl/baltip/files/tt1.png" class="media" alt="">

*More standard*.  The tip's font is configured to be more standard.

 <img src="https://aplsimple.github.io/en/tcl/baltip/files/tt2.png" class="media" alt="">

*Label of danger*. The labels are also tipped. This one is configured to be an alert.

 <img src="https://aplsimple.github.io/en/tcl/baltip/files/tt3.png" class="media" alt="">

*Button's tip*. This button has its own tip, being a caller of a balloon at that.

 <img src="https://aplsimple.github.io/en/tcl/baltip/files/tt4.png" class="media" alt="">

*Balloon*. The balloon appears at the top right corner. After a while it disappears.

 <img src="https://aplsimple.github.io/en/tcl/baltip/files/tt5.png" class="media" alt="">

## Usage

The *baltip* usage is rather straightforward. Firstly we need *package require*:

      lappend auto_path "dir_of_baltip"
      package require baltip

Then we set tips with `::baltip::tip` command for each appropriate widget:

      ::baltip::tip widgetpath text ?-option value?
      # or this way:
      ::baltip tip widgetpath text ?-option value?

For example, having a button *.win.but1*, we can set its tip this way:

      ::baltip tip .win.but1 "It's a tip.\n2nd line of it.\n3rd."

To get all or specific settings *baltip* settings:

      ::baltip::cget
      ::baltip::cget -option ?-option?
      # or this way:
      ::baltip cget
      ::baltip cget -option ?-option?

To set some options:

      ::baltip::configure -option value ?-option value?
      # or this way:
      ::baltip config -option value ?-option value?

**Note**: the options set with `configure` command are *global*, i.e. active for all tips.
The options set with `tip` command are *local*, i.e. active for the specific tip.

To make all (or specific) tips use the global settings:

      ::baltip::update ?widgetpath?

To disable all tips:

      ::baltip::configure -on false

To disable some specific tip:

      ::baltip::tip widgetpath ""
      # or this way:
      ::baltip::tip widgetpath "old tip" -on false

To hide some specific (suspended) tip forcedly:

      ::baltip::hide widgetpath

When you click on a widget with tip being displayed, the tip is hidden. It is the default behavior of *baltip*, but sometimes you need to re-display the hidden tip. If the widget is a button, you can include the following command in `-command` of the button:

      ::baltip::repaint widgetpath

## Balloon

The *normal* tip has no `-geometry` option because it's calculated by *baltip*.

So, with `-geometry` option you get a balloon message unrelated to any visible widget (it's made on the toplevel window). The `-geometry` option has +X+Y form where X and Y are coordinates of the balloon.

For example:

      ::baltip::tip .win "It's a balloon at +1+100 (+X+Y) coordinates" \
        -geometry +1+100 -font {-weight bold -size 12} \
        -alpha 0.8 -fg white -bg black -per10 3000 -pause 1500 -fade 1500

The `-pause` and `-fade` options make the balloon fade at appearing and disappearing. The `-per10` option defines the balloon's duration: the more the longer.

The `-geometry` value can include `W` and `H` *wildcards* meaning the width and the height of the balloon. This may be useful when you need to show a balloon at a window's edge and should use the balloon's dimensions which are available only after its creation. The X and Y coordinates are calculated by *baltip* as normal expressions. Of course, they should not include the "+" divider, but this restriction (if any) is easily overcome.

For example:

      lassign [split [winfo geometry .win] x+] w h x y
      set geom "+([expr {$w+$x}]-W-4)+$y"
      set text "The balloon at the right edge of the window"
      ::baltip tip .win $text -geometry $geom -pause 2000 -fade 2000

As seen in the above examples, the *baltip* can be used as Tcl ensemble, so that the commands may be shortened.

## Options

Below are listed the *baltip* options that are set with `tip` and `configure` and got with `cget`:

 **-on** - switches all tips on/off;
 **-per10** - a time of exposition per 10 characters (in millisec.); "0" means "eternal";
 **-fade** - a time of fading (in millisec.);
 **-pause** - a pause before displaying tips (in millisec.);
 **-alpha** - an opacity (from 0.0 to 1.0);
 **-fg** - foreground of tip;
 **-bg** - background of tip;
 **-bd** - borderwidth of tip;
 **-font** - font attributes;
 **-padx** - X padding for text;
 **-pady** - Y padding for text;
 **-padding** - padding for pack.

The following options are special:

 **-force** - if true, forces the display by 'tip' command;
 **-index** - index of menu item to tip;
 **-tag** - name of text tag to tip;
 **-geometry** - geometry (+X+Y) of the balloon.

## Links

  * [Reference](https://aplsimple.github.io/en/tcl/baltip/baltip.html)

  * [Source](https://chiselapp.com/user/aplsimple/repository/baltip/download) (baltip.zip)

You can test the *baltip* with *test2_pave.tcl* of the *apave* package available at:

  * [apave package](https://chiselapp.com/user/aplsimple/repository/pave/download) (pave.zip)

Note that [baltip](https://chiselapp.com/user/aplsimple/repository/baltip/download) is still disposed to updating.
}
}

namespace eval ::baltip::my {
  variable _ruff_preamble {
    The `::baltip::my` namespace contains procedures for the "internal" usage by *baltip* package.

    All of them are upper-cased, in contrast with the UI procedures of `baltip` namespace.
  }
}
