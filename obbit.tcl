# _______________________________________________________________________ #
#
# This script contains a bunch of oo::classes. A bit of it.
#
# The ObjectProperty class allows to mix-in into
# an object the getter and setter of properties.
#
# The ObjectTheming class allows to change the ttk widgets' style.
#
# _______________________________________________________________________ #

package require Tk

namespace eval ::apave {

  # variables global to apave objects:

  # - common options/constants of apave utils
  variable _PU_opts
  array set _PU_opts [list -NONE =NONE=]
  # - main color scheme data
  variable ::apave::_CS_
  array set ::apave::_CS_ [list]
  # - current color scheme data
  variable ::apave::_C_
  array set ::apave::_C_ [list]
  set ::apave::_CS_(initall) 1
  set ::apave::_CS_(initWM) 1
  set ::apave::_CS_(textFont) "Mono"
  set ::apave::_CS_(!FG) #000000
  set ::apave::_CS_(!BG) #c3c3c3
  set ::apave::_CS_(expo,tfg1) "-"
             # = text1   fg   item bg    bg   itemsHL  actbg   actfg     cc    greyed   hot
             # clrtitf clrinaf clrtitb clrinab clrhelp clractb clractf clrcurs clrgrey clrhotk    fI      bI   -fM-   bM
  set ::apave::_CS_(ALL) {
{MildDark      #E8E8E8 #E7E7E7 #222A2F #2D435B #FEEFA8 #566982 black   #4EADAD grey    #76b0c3 #000000 #697c95 - #3c546e #000 #001 #002 #003 #004 #005 #006 #007}
{Inkpot #d3d3ff #AFC2FF #05050e #1E1E27 #a4a4e5 #4E4E8F #fdfdfd #EDC881 grey orange #fdfdfd #4E4E8F - #292936 #000 #001 #002 #003 #004 #005 #006 #007}
{Green         #E8E8E8 #EFEFEF #0F3F0A #274923 #FEEC9A #5d7b66 black #E69800 grey #E69800 #000000 #6f8d78 - #3e603a #000 #001 #002 #003 #004 #005 #006 #007}
{Brown         #E8E8E8 #E7E7E7 #352927 #453528 #FEEC9A #716146 white #E69800 grey #E69800 white #645439 - #524235 #000 #001 #002 #003 #004 #005 #006 #007}
{Magenta       #E8E8E8 #F0E8E8 #2B1137 #4A2A4A #FEEC9A #805b9d black #E69800 grey #E69800 #000000 #af8acc - #573757 #000 #001 #002 #003 #004 #005 #006 #007}
{Red           white   #CECECB #340202 #440702 yellow  #903e3e black #D90505 #440701 orange black #ba6868 - #440702 #000 #001 #002 #003 #004 #005 #006 #007}
{Anti-Light1 #bebebe #bebebe #333333 #242424 #FEEFA8 #141414 #bebebe #ffffff grey    #70C6C6 #bebebe black - #1c1c1c #000 #001 #002 #003 #004 #005 #006 #007}
{Anti-Light2 #bebebe #bebebe #242424 #333333 #FEEFA8 #636363 black  #ffffff grey    #70C6C6 #000000 #747474 - #2b2b2b #000 #001 #002 #003 #004 #005 #006 #007}
{Darcula #dedede #A1ACB6 #272727 #303030 #B09869 #2F5692 #EDC881 #EDC881 grey #f0a471 #EDC881 #1a417d - #444444 #000 #001 #002 #003 #004 #005 #006 #007}
{Sleepy #daefd0 #D0D0D2 #3b4043 #2E3436 #CB956D #626D71 #f8f8f8 white grey #B0B000 white #6c6c6c - #383E40 #000 #001 #002 #003 #004 #005 #006 #007}
{Dark          #E0D9D9 #C4C4C4 #232323 #303030 #CCCC90 #595959 black #E69800 grey #E69800 #000000 #858585 - #424242 #000 #001 #002 #003 #004 #005 #006 #007}
{DarkGrey      #F0E8E8 #E7E7E7 #333333 #494949 #DCDC9B #727272 black #E69800 grey #E69800 #000000 #9f9f9f - #595959 #000 #001 #002 #003 #004 #005 #006 #007}
{Sandy         #211D1C #27201F #FEFAEB #F7EEC5 #523A0A #b2a47f #3b1609  #B66425 grey    #933232 #FFFFFF #82744F - #e4dbb2 #000 #001 #002 #003 #004 #005 #006 #007}
{African black black #ffe2a2 #ffffb4 brown #d3a876 #000000 red grey SaddleBrown #3b1516 #f9b777 - #ffffd0 #000 #001 #002 #003 #004 #005 #006 #007}
{Rosy          #2B122A #000000 #FFFFFF #F6E6E9 #570957 #C5ADC8 black #C84E91 grey #870287 #000000 #C5ADC8 - #d6c6c9 #000 #001 #002 #003 #004 #005 #006 #007}
{InverseGrey   #121212 #1A1A1A #c9cbcf #DADCE0 #302206 #a4a6aa black #B66425 #DADCE1 #933232 #FFFFFF #777777 - #c9cbcf #000 #001 #002 #003 #004 #005 #006 #007}
{Gray          #000000 #0D0D0D #FFFFFF #DADCE0 #362607 #AFAFAF black #B66425 grey #933232 #000000 #AFAFAF - #caccd0 #000 #001 #002 #003 #004 #005 #006 #007}
{Anti-Dark1 #2e3436 #2e3436 #F8F8F8 #dadad8 #362607 #AFAFAF black #B66425 grey #933232 #000000 #AFAFAF - #caccd0 #000 #001 #002 #003 #004 #005 #006 #007}
{Anti-Dark2 #2e3436 #2e3436 #dadad8 #F8F8F8 #362607 #AFAFAF black #B66425 grey #933232 #000000 #AFAFAF - #e1e1df #000 #001 #002 #003 #004 #005 #006 #007}
{Florid black darkgreen #dbffdb white brown #88cd88 #003300 red grey #933232 black lightgreen - #dff4df #000 #001 #002 #003 #004 #005 #006 #007}
{LightGreen    #122B05 #091900 #FFFFFF #DEF8DE #562222 #A8CCA8 black #B66425 grey #933232 #000000 #A8CCA8 - #c3ddc3 #000 #001 #002 #003 #004 #005 #006 #007}
{InverseGreen  #122B05 #091900 #cce6c8 #DEF8DE #562222 #9cc09c black #B66425 #DEF8D1 #933232 #FFFFFF #6c916c - #cce6cc #000 #001 #002 #003 #004 #005 #006 #007}
{Khakish       #2e3436 #2e3436 #e1ffdd #cadfca #933232 #9dbb99 black #FF8A00 grey #AE5F02 #000000 #9cb694 - #bcdab8 #000 #001 #002 #003 #004 #005 #006 #007}
{Blue          #08085D #030358 #FFFFFF #D2DEFA #562222 #94abde black #B66425 grey #933232 black #a5bcef - #b7c3df #000 #001 #002 #003 #004 #005 #006 #007}
{Sky           #102433 #0A1D33 #D2EAF2 #AFDFEF #0D3239 #72b5c9 black #2A8CBD grey #1261AD black #7bbed2 - #96c6d6 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-SourceForge #141414 #151616 #ffffff #99d2f5 #723600 #75aed1 black #0058bf grey #c44e28 black #7aa2c5 - #8ac3e6 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-Juicy #000000 #000000 #f1f1f1 #dddddd #000000 #bfbfbf black #a4cd52 grey #933232 black #a9a9a9 - #d3d3d3 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-FluidVision #000000 #000000 #f4f4f4 #cccccc #000000 #a3a3a3 black #999999 grey #933232 #FFFFFF #777777 - #BABABA #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-YellowStone #0000ff #00003c #fdf9d0 #d5d2af #00003c #d59d6f black #85836e grey #771d00 #00003c #e6ae80 - #DBD8B5 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-TurnOfCentury #333333 #333333 #d6c4b6 #ae9f94 #333333 #d59d6f black #4A3706 grey #771d00 black #e6ae80 - #a5968b #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-Notebook #000000 #000000 #beb69d #96907c #000000 #d59d6f black #336e30 grey #771d00 #000000 #e6ae80 - #85806E #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-IdleFingers #ffffff #ffffff #323232 #5a5a5a #ffffff #395472 white #d7e9c3 grey orange #ffffff #2d4866 - #4F4F4F #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-Minimal #fcffe0 #ffffff #302d26 #5a5a5a #ffffff #395472 white #ff9900 grey orange #ffffff #2e4967 - #4F4F4F #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-Monokai #f8f8f2 #f8f8f2 #272822 #4e5044 #f8f8f2 #3e3f35 white #999d86 grey orange #f8f8f2 #393a34 - #505147 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-LightVision #ffffff #ffffff #3C423C #515753 #ffc2a1 #6f756f black #0089f0 grey orange #ffc2a1 #2c322e - #474D49 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-oscuro #f1f1f1 #f1f1f1 #344545 #526d6d #f1f1f1 #162727 white #e87e88 grey orange #f1f1f1 #344545 - #475E5E #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-StarLight #C0B6A8 #C0B6A8 #223859 #315181 #C0B6A8 #0e2445 #C0B6A8 #4e81ce grey orange #C0B6A8 #122849 - #2D4A75 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-MildDark #d2d2d2 #ffffff #151616 #43576e #ffbe00 #283b54 white #00a0f0 grey #ffbb6d #ffbe00 #283e56 - #384b64 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-MildDark2 #b4b4b4 #ffffff #0d0e0e #324864 #ffbe00 #192c45 white #00ffff grey #ffbb6d #ffbe00 #1e344c - #2B3E57 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-MildDark3 #e2e2e2 #f1f1f1 #000000 #24384f #ffbe00 #0b1e37 white #00ffff grey #ffbb6d #ffbe00 #041a32 - #1F3145 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-RubyBlue #ffffff #ffffff #121e31 #213659 #ffffff #395472 white #336e30 grey orange #ffffff #435e7c - #1C2E4D #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-MadeOfCode #f8f8f8 #f8f8f8 #090a1b #00348c #f8f8f8 #042154 white #4c60ae grey orange #f8f8f8 #00174a - #002C78 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-CoolGlow #e0e0e0 #e0e0e0 #06071d #0e1145 #e0e0e0 #253296 white #7600fe grey orange #e0e0e0 #3542a6 - #171C73 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-Quiverly #b6c1c1 #b6c1c1 #2b303b #333946 #fbffd7 #395472 white #ff9900 grey orange #FBFCEF #4b6684 - #414650 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-Aurora #ececec #ececec #302e40 #4e4b68 #ececec #151325 white #ffffff grey orange #ececec #302e40 - #434259 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-Choco #c3be98 #c3be98 #180c0c #402020 #c3be98 #664D4D white #6c6c6c grey orange white #735a5a - #331A1A #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-AnatomyOfGrey #dfdfdf #ffffff #000000 #282828 #ffffff #565656 black #4e5044 grey orange #ffffff #000000 - #363636 #000 #001 #002 #003 #004 #005 #006 #007}
{TKE-Default white white black #282828 white blue white #9fa608 grey orange white black - #383838 #000 #001 #002 #003 #004 #005 #006 #007}
}
#-RUNF1: ./tests/test2_pave.tcl
#RUNF1: ./tests/test2_pave.tcl 14 11 12

  set ::apave::_CS_(NONCS) -2
  set ::apave::_CS_(MINCS) -1
  set ::apave::_CS_(STDCS) [expr {[llength $::apave::_CS_(ALL)] - 1}]
  set ::apave::_CS_(MAXCS) $::apave::_CS_(STDCS)
  set ::apave::_CS_(old) $::apave::_CS_(NONCS)

  set ::apave::_CS_(defFont) [ttk::style lookup "." -font]
  set ::apave::_CS_(def_FontSize) [font config $::apave::_CS_(defFont) -size]
  set ::apave::_CS_(fs) $::apave::_CS_(def_FontSize)
  set ::apave::_CS_(untouch) [list]
}

# _______________________________________________________________________ #

proc ::iswindows {} {

  # Checks if the platform is MS Windows.
  return [expr {$::tcl_platform(platform) eq "windows"} ? 1: 0]
}

#########################################################################

proc ::apave::initPOP {w} {

  # Initializes system popup menu (if possible) to call it in a window.
  #   w - window's name

  bind $w <KeyPress> {
    if {"%K" eq "Menu"} {
      if {[winfo exists [set w [focus]]]} {
        event generate $w <Button-3> -rootx [winfo pointerx .] \
         -rooty [winfo pointery .]
      }
    }
  }
}

#########################################################################

proc ::apave::initWM {} {

  # Initializes Tcl/Tk session. Used to be called at the beginning of it.

  if {!$::apave::_CS_(initWM)} return
  set ::apave::_CS_(initWM) 0
  if {$::tcl_platform(platform) == "windows"} {
    wm attributes . -alpha 0.0
  } else {
    wm withdraw .
  }
  ttk::style map "." \
    -selectforeground [list !focus $::apave::_CS_(!FG)] \
    -selectbackground [list !focus $::apave::_CS_(!BG)]
  # configure separate widget types
  try {ttk::style theme use clam}
  ttk::style configure TButton \
    -anchor center -width -8 -relief raised -borderwidth 1 -padding 1
  ttk::style configure TLabel -borderwidth 0 -padding 1
  ttk::style configure TMenubutton -width 0 -padding 0
  catch { tooltip::tooltip fade true }
  initPOP .
  return
}

#########################################################################

proc ::apave::cs_Non {} {

  # Gets non-existent CS index

  return $::apave::_CS_(NONCS)
}

#########################################################################

proc ::apave::cs_Min {} {

  # Gets a minimum index of available color schemes

  return $::apave::_CS_(MINCS)
}

proc ::apave::cs_Max {} {

  # Gets a maximum index of available color schemes

  return $::apave::_CS_(MAXCS)
}

###########################################################################

proc ::apave::getN {sn {defn 0} {min ""} {max ""}} {

  # Gets a number from a string
  #   sn - string containing a number
  #   defn - default value when sn is not a number
  #   min - minimal value allowed
  #   max - maximal value allowed

  if {$sn eq "" || [catch {set sn [expr {$sn}]}]} {set sn $defn}
  if {$max ne ""} {
    set sn [expr {min($max,$sn)}]
  }
  if {$min ne ""} {
    set sn [expr {max($min,$sn)}]
  }
  return $sn
}

###########################################################################

proc ::apave::parseOptionsFile {strict inpargs args} {

  # Parses argument list containing options and (possibly) a file name.
  #   strict - if 0, 'args' options will be only counted for,
  #              other options are skipped
  #   strict - if 1, only 'args' options are allowed,
  #              all the rest of inpargs to be a file name
  #          - if 2, the 'args' options replace the
  #              appropriate options of 'inpargs'
  #   inpargs - list of options, values and a file name
  #   args  - list of default options
  #
  # The inpargs list contains:
  #   - option names beginning with "-"
  #   - option values following their names (may be missing)
  #   - "--" denoting the end of options
  #   - file name following the options (may be missing)
  #
  # The *args* parameter contains the pairs:
  #   - option name (e.g., "-dir")
  #   - option default value
  #
  # If the *args* option value is equal to =NONE=, the *inpargs* option
  # is considered to be a single option without a value and,
  # if present in inpargs, its value is returned as "yes".
  #
  # If any option of *inpargs* is absent in *args* and strict==1,
  # the rest of *inpargs* is considered to be a file name.
  #
  # The proc returns a list of two items:
  #   - an option list got from args/inpargs according to 'strict'
  #   - a file name from inpargs or {} if absent
  #
  # Examples see in tests/obbit.test.

  variable _PU_opts
  set actopts true
  array set argarray "$args yes yes" ;# maybe, tail option without value
  if {$strict==2} {
    set retlist $inpargs
  } else {
    set retlist $args
  }
  set retfile {}
  for {set i 0} {$i < [llength $inpargs]} {incr i} {
    set parg [lindex $inpargs $i]
    if {$actopts} {
      if {$parg=="--"} {
        set actopts false
      } elseif {[catch {set defval $argarray($parg)}]} {
        if {$strict==1} {
          set actopts false
          append retfile $parg " "
        } else {
          incr i
        }
      } else {
        if {$strict==2} {
          if {$defval == $_PU_opts(-NONE)} {
            set defval yes
          }
          incr i
        } else {
          if {$defval == $_PU_opts(-NONE)} {
            set defval yes
          } else {
            set defval [lindex $inpargs [incr i]]
          }
        }
        set ai [lsearch -exact $retlist $parg]
        incr ai
        set retlist [lreplace $retlist $ai $ai $defval]
      }
    } else {
      append retfile $parg " "
    }
  }
  return [list $retlist [string trimright $retfile]]
}

###########################################################################

proc ::apave::parseOptions {inpargs args} {

  # Parses argument list containing options.
  #  inpargs - list of options and values
  #  args  - list of option/defaultvalue repeated pairs
  #
  # It's the same as parseOptionsFile, excluding the file name stuff.
  #
  # Returns a list of options' values, according to args.
  #
  # See also: parseOptionsFile

  lassign [::apave::parseOptionsFile 0 $inpargs {*}$args] tmp
  foreach {nam val} $tmp {
    lappend retlist $val
  }
  return $retlist
}

###########################################################################

proc ::apave::getOption {optname args} {

  # Extracts one option from an option list.
  #   optname - option name
  #   args - option list
  # Returns an option value or "".
  # Example:
  #     set options [list -name some -value "any value" -tooltip "some tip"]
  #     set optvalue [::apave::getOption -tooltip {*}$options]

  lassign [::apave::parseOptions $args $optname ""] optvalue
  return $optvalue
}

###########################################################################

proc ::apave::putOption {optname optvalue args} {

  # Replaces or adds one option to an option list.
  #   optname - option name
  #   optvalue - option value
  #   args - option list
  # Returns an updated option list.

  set optlist {}
  set doadd true
  foreach {a v} $args {
    if {$a eq $optname} {
      set v $optvalue
      set doadd false
    }
    lappend optlist $a $v
  }
  if {$doadd} {lappend optlist $optname $optvalue}
  return $optlist
}

#########################################################################

proc ::apave::removeOptions {options args} {

  # Removes some options from a list of options.
  #   options - list of options and values
  #   args - list of option names to remove
  #
  # The `options` may contain "key value" pairs and "alone" options
  # without values.
  #
  # To remove "key value" pairs, `key` should be an exact name.
  #
  # To remove an "alone" option, `key` should be a glob pattern with `*`.

  foreach key $args {
    if {[set i [lsearch -exact $options $key]]>-1} {
      catch {
        # remove a pair "option value"
        set options [lreplace $options $i $i]
        set options [lreplace $options $i $i]
      }
    } elseif {[string first * $key]>=0 && \
      [set i [lsearch -glob $options $key]]>-1} {
      # remove an option only
      set options [lreplace $options $i $i]
    }
  }
  return $options
}

###########################################################################

proc ::apave::readTextFile {fileName {varName ""} {doErr 0}} {

  # Reads a text file.
  #   fileName - file name
  #   varName - variable name for file content or ""
  #   doErr - if 'true', exit at errors with error message
  #
  # Returns file contents or "".

  if {$varName ne ""} {upvar $varName fvar}
  if {[catch {set chan [open $fileName]} e]} {
    if {$doErr} {error "\n readTextFile: can't open \"$fileName\"\n $e"}
    set fvar ""
  } else {
    chan configure $chan -encoding utf-8
    set fvar [read $chan]
    close $chan
  }
  return $fvar
}

###########################################################################
#
# 1st bit: Set/Get properties of object.
#
# Call of setter:
#   oo::define SomeClass {
#     mixin ObjectProperty
#   }
#   SomeClass create someobj
#   ...
#   someobj setProperty Prop1 100
#
# Call of getter:
#   oo::define SomeClass {
#     mixin ObjectProperty
#   }
#   SomeClass create someobj
#   ...
#   someobj getProperty Alter 10
#   someobj getProperty Alter

oo::class create ::apave::ObjectProperty {

  variable _OP_Properties

  constructor {args} {
    array set _OP_Properties {}
    # ObjectProperty can play solo or be a mixin
    if {[llength [self next]]} { next {*}$args }
  }

  destructor {
    array unset _OP_Properties
    if {[llength [self next]]} next
  }

# _______________________________________________________________________ #

  method setProperty {name args} {

    # Sets a property's value.
    #   name - name of property
    #   args - value of property
    #
    # If *args* is omitted, the method returns a property's value.
    #
    # If *args* is set, the method sets a property's value as $args.

    switch [llength $args] {
      0 {return [my getProperty $name]}
      1 {return [set _OP_Properties($name) $args]}
    }
    puts -nonewline stderr \
      "Wrong # args: should be \"[namespace current] setProperty propertyname ?value?\""
    return -code error
  }

  ###########################################################################

  method getProperty {name {defvalue ""}} {

    # Gets a property's value.
    #   name - name of property
    #   defvalue - default value
    #
    # If the property had been set, the method returns its value.
    #
    # Otherwise, the method returns the default value (`$defvalue`).

    if [info exists _OP_Properties($name)] {
      return $_OP_Properties($name)
    }
    return $defvalue
  }

}

###########################################################################
# Another bit - theming manager

oo::class create ::apave::ObjectTheming {

  mixin ::apave::ObjectProperty

  constructor {args} {
    my InitCS
    # ObjectTheming can play solo or be a mixin
    if {[llength [self next]]} { next {*}$args }
  }

  destructor {
    if {[llength [self next]]} next
  }

  ###########################################################################

  method InitCS {} {

    # Initializes the color scheme processing.

    if {$::apave::_CS_(initall)} {
      my basicFontSize 10 ;# initialize main font size
      my basicTextFont $::apave::_CS_(textFont) ;# initialize main font for text
      my ColorScheme  ;# initialize default colors
      set ::apave::_CS_(initall) 0
    }
    return
  }

  ###########################################################################

  method Create_Fonts {} {
    # Creates fonts used in apave.

    catch {font delete apaveFontMono}
    catch {font delete apaveFontDef}
    font create apaveFontMono -family $::apave::_CS_(textFont) -size $::apave::_CS_(fs)
    font create apaveFontDef -family $::apave::_CS_(defFont) -size $::apave::_CS_(fs)
  }

  ###########################################################################

  method Main_Style {tfg1 tbg1 tfg2 tbg2 tfgS tbgS bclr tc fA bA bD} {

    # Sets main colors of application
    #   tfg1 - main foreground
    #   tbg1 - main background
    #   tfg2 - not used
    #   tbg2 - not used
    #   tfgS - selectforeground
    #   tbgS - selectbackground
    #   bclr - bordercolor
    #   tc - troughcolor
    #   fA - foreground active
    #   bA - background active
    #   bD - background disabled
    #
    # The *foreground disabled* is set as `grey`.

    my Create_Fonts
    ttk::style configure "." \
      -background        $tbg1 \
      -foreground        $tfg1 \
      -bordercolor       $bclr \
      -darkcolor         $tbg1 \
      -lightcolor        $tbg1 \
      -troughcolor       $tc \
      -arrowcolor        $tfg1 \
      -selectbackground  $tbgS \
      -selectforeground  $tfgS \
      ;#-selectborderwidth 0
    ttk::style map "." \
      -background       [list disabled $bD active $bA] \
      -foreground       [list disabled grey active $fA]
  }

  ###########################################################################

  method ColorScheme {{ncolor ""}} {

    # Gets a full record of color scheme from a list of available ones
    #   ncolor - index of color scheme

    if {"$ncolor" eq "" || $ncolor<0} {
      # basic color scheme: get colors from a current ttk::style colors
      if {[info exists ::apave::_CS_(def_fg)]} {
        set fg $::apave::_CS_(def_fg)
        set bg $::apave::_CS_(def_bg)
        set fS $::apave::_CS_(def_fS)
        set bS $::apave::_CS_(def_bS)
        set bA $::apave::_CS_(def_bA)
      } else {
        set ::apave::_CS_(index) $::apave::_CS_(NONCS)
        lassign [::apave::parseOptions [ttk::style configure .] \
          -foreground #000000 -background #d9d9d9 -troughcolor #c3c3c3] fg bg tc
        set fS black
        set bS #9cb0c6
        lassign [::apave::parseOptions [ttk::style map . -background] \
          disabled #d9d9d9 active #ececec] bD bA
        lassign [::apave::parseOptions [ttk::style map . -foreground] \
          disabled #a3a3a3] fD
        lassign [::apave::parseOptions [ttk::style map . -selectbackground] \
          !focus #9e9a91] bclr
        set ::apave::_CS_(def_fg) $fg
        set ::apave::_CS_(def_bg) $bg
        set ::apave::_CS_(def_fS) $fS
        set ::apave::_CS_(def_bS) $bS
        set ::apave::_CS_(def_fD) $fD
        set ::apave::_CS_(def_bD) $bD
        set ::apave::_CS_(def_bA) $bA
        set ::apave::_CS_(def_tc) $tc
        set ::apave::_CS_(def_bclr) $bclr
      }
      return [list default \
           $fg    $fg     $bA    $bg     $fg     $bS     $fS    #1E90FF  grey   #4f6379 $fS $bS - $bg]
      # clrtitf clrinaf clrtitb clrinab clrhelp clractb clractf clrcurs clrgrey clrhotk fI  bI fM bM
    }
    return [lindex $::apave::_CS_(ALL) $ncolor]
  }

# _______________________________________________________________________ #

  method basicFontSize {{fs 0}} {

    # Gets/Sets a basic size of font used in apave
    #    fs - font size
    #
    # If 'fs' is omitted or ==0, this method gets it.
    # If 'fs' >0, this method sets it.

    if {$fs} {
      return [set ::apave::_CS_(fs) $fs]
    } else {
      return $::apave::_CS_(fs)
    }
  }

  ###########################################################################

  method basicTextFont {{textfont ""}} {

    # Gets/Sets a basic font used in editing/viewing text widget
    #    textfont - font
    #
    # If 'textfont' is omitted or =="", this method gets it.
    # If 'textfont' is set, this method sets it.

    if {$textfont ne ""} {
      return [set ::apave::_CS_(textFont) $textfont]
    } else {
      return $::apave::_CS_(textFont)
    }
  }

  ###########################################################################

  method csFont {fontname} {
    # Returns attributes of CS font.
    if {[catch {set font [font configure $fontname]}]} {
      my Create_Fonts
      set font [font configure $fontname]
    }
    return $font
  }

  method csFontMono {} {
    # Returns attributes of CS monotype font.
    return [my csFont apaveFontMono]
  }

  method csFontDef {} {
    # Returns attributes of CS default font.
    return [my csFont apaveFontDef]
  }

  ###########################################################################

  method csDarkEdit {} {

    # Returns a flag "the editor of CS is dark"

    set cs [my csCurrent]
    return [expr {$cs>-1 && $cs <12 || $cs>30}]
  }

  ###########################################################################

  method csExport {} {

    # TODO

    set theme ""
    foreach arg {tfg1 tbg1 tfg2 tbg2 tfgS tbgS tfgD tbgD tcur bclr args} {
      if {[catch {set a "$::apave::_CS_(expo,$arg)"}] || $a==""} {
        break
      }
      append theme " $a"
    }
    return $theme
  }

  ###########################################################################

  method csCurrent {} {

    # Gets an index of current color scheme

    return $::apave::_CS_(index)
  }

  ###########################################################################

  method csGetName {{ncolor 0}} {

    # Gets a color scheme's name
    #   ncolor - index of color scheme

    if {$ncolor < $::apave::_CS_(MINCS)} {
      return "Default"
    } elseif {$ncolor == $::apave::_CS_(MINCS)} {
      return "Basic"
    }
    return [lindex [my ColorScheme $ncolor] 0]
  }

  ###########################################################################

  method csGet {{ncolor ""}} {

    # Gets a color scheme's colors
    #   ncolor - index of color scheme

    if {$ncolor eq ""} {set ncolor [my csCurrent]}
    return [lrange [my ColorScheme $ncolor] 1 end]
  }

  ###########################################################################

  method csSet {{ncolor 0} {win .} args} {

    # Sets a color scheme and applies it to Tk/Ttk widgets.
    #   ncolor - index of color scheme (0 through $::apave::_CS_(MAXCS))
    #   win - window's name
    #   args - list of colors if ncolor=""
    #
    # The `args` can be set as "-doit". In this case the method does set
    # the `ncolor` color scheme (otherwise it doesn't set the CS if it's
    # already of the same `ncolor`).

    # The clrtitf, clrinaf etc. had been designed for e_menu. And as such,
    # they can be used directly, outside of this "color scheming" UI.
    # They set pairs of related fb/bg:
    #   clrtitf/clrtitb is item's fg/bg
    #   clrinaf/clrinab is main fg/bg
    #   clractf/clractb is active (selection) fg/bg
    # and separate colors:
    #   clrhelp is "help" foreground
    #   clrcurs is "caret" background
    #   clrgrey is "shadowing" background
    #   clrhotk is "hotkey/border" foreground
    #
    # In color scheming, these colors are transformed to be consistent
    # with Tk/Ttk's color mechanics.
    #
    # Additionally, "grey" color is used as "border color/disabled foreground".
    #
    # Returns a list of colors used by the color scheme.

    if {$ncolor eq ""} {
      lassign $args \
        clrtitf clrinaf clrtitb clrinab clrhelp clractb clractf clrcurs clrgrey clrhotk tfgI tbgI fM bM
    } else {
      foreach cs [list $ncolor $::apave::_CS_(MINCS)] {
        lassign [my csGet $cs] \
          clrtitf clrinaf clrtitb clrinab clrhelp clractb clractf clrcurs clrgrey clrhotk tfgI tbgI fM bM
        if {$clrtitf ne ""} break
        set ncolor $cs
      }
      set ::apave::_CS_(index) $ncolor
    }
    set fg $clrinaf  ;# main foreground
    set bg $clrinab  ;# main background
    set fE $clrtitf  ;# fieldforeground foreground
    set bE $clrtitb  ;# fieldforeground background
    set fS $clractf  ;# active/selection foreground
    set bS $clractb  ;# active/selection background
    set hh $clrhelp  ;# (not used in cs' theming) title color
    set gr $clrgrey  ;# (not used in cs' theming) shadowing color
    set cc $clrcurs  ;# caret's color
    set ht $clrhotk  ;# hotkey color
    set grey #808080
    if {$::apave::_CS_(old) != $ncolor || $args eq "-doit"} {
      set ::apave::_CS_(old) $ncolor
      my themeWindow $win $fg $bg $fE $bE $fS $bS $grey $bg $cc $ht $hh $tfgI $tbgI $fM $bM
    }
    return [list $fg $bg $fE $bE $fS $bS $hh $gr $cc $ht $tfgI $tbgI $fM $bM]
  }

  ###########################################################################

  method csAdd {newcs {setnew true}} {

    # Registers new color scheme in the list of CS.
    #   newcs -  CS item
    #   setnew - if true, sets the CS as current
    #
    # Does not register the CS, if it is already registered.
    #
    # Returns an index of current CS.
    #
    # See also:
    #   themeWindow

    if {[llength $newcs]<4} {
      set newcs [my ColorScheme]  ;# CS should be defined
    }
    lassign $newcs name tfg2 tfg1 tbg2 tbg1 tfhh - - tcur grey bclr
    set found $::apave::_CS_(NONCS)
    for {set i $::apave::_CS_(MINCS)} {$i<=$::apave::_CS_(MAXCS)} {incr i} {
      lassign [my csGet $i] cfg2 cfg1 cbg2 cbg1 cfhh - - ccur
      if {$cfg2==$tfg2 && $cfg1==$tfg1 && $cbg2==$tbg2 && $cbg1==$tbg1 && \
      $cfhh==$tfhh && $ccur==$tcur} {
        set found $i
        break
      }
    }
    if {$found == $::apave::_CS_(MINCS) && [my csCurrent] == $::apave::_CS_(NONCS)} {
      set setnew false ;# no moves from default CS to 'basic'
    } elseif {$found == $::apave::_CS_(NONCS)} {
      lappend ::apave::_CS_(ALL) $newcs
      set found [incr ::apave::_CS_(MAXCS)]
    }
    if {$setnew} {set ::apave::_CS_(index) [set ::apave::_CS_(old) $found]}
    return [my csCurrent]
  }

# _______________________________________________________________________ #

  method Ttk_style {oper ts opt val} {

    # Sets a new style options.
    #   oper - command of ttk::style ("map" or "configure")
    #   ts - type of style to be configurated
    #   opt - option's name
    #   val - option's value

    if {![catch {set oldval [ttk::style $oper $ts $opt]}]} {
      catch {ttk::style $oper $ts $opt $val}
      if {$oldval=="" && $oper=="configure"} {
        switch -- $opt {
          -foreground - -background {
            set oldval [ttk::style $oper . $opt]
          }
          -fieldbackground {
            set oldval white
          }
          -insertcolor {
            set oldval black
          }
        }
      }
    }
    return
  }

  ###########################################################################

  method themeWindow {win {tfg1 ""} {tbg1 ""} {tfg2 ""} {tbg2 ""} {tfgS ""}
    {tbgS ""} {tfgD ""} {tbgD ""} {tcur ""} {bclr ""}
    {thlp ""} {tfgI ""} {tbgI ""} {tfgM ""} {tbgM ""}
    {isCS true} args} {

    # Changes a Tk style (theming a bit)
    #   win - window's name
    #   tfg1 - foreground for themed widgets (main stock)
    #   tbg1 - background for themed widgets (main stock)
    #   tfg2 - foreground for themed widgets (enter data stock)
    #   tbg2 - background for themed widgets (enter data stock)
    #   tfgS - foreground for selection
    #   tbgS - background for selection
    #   tfgD - foreground for disabled themed widgets
    #   tbgD - background for disabled themed widgets
    #   tcur - insertion cursor color
    #   bclr - hotkey/border color
    #   thlp - help color
    #   tfgI - foreground for external CS
    #   tbgI - background for external CS
    #   tfgM - foreground for menus
    #   tbgM - background for menus
    #   isCS - true, if the colors are taken from a CS
    #   args - other options
    #
    # The themeWindow can be used outside of "color scheme" UI.
    # E.g., in TKE editor, e_menu and add_shortcuts plugins use it to
    # be consistent with TKE theme.

    if {$tfg1 eq "-"} return
    if {!$isCS} {
      # if 'external  scheme' is used, register it in _CS_(ALL)
      # and set it as the current CS
      my csAdd [list CS-[expr {$::apave::_CS_(MAXCS)+1}] \
        $tfg2 $tfg1 $tbg2 $tbg1 $thlp $tbgS $tfgS $tcur grey $bclr $tfgI $tbgI $tfgM $tbgM]
    }
    if {$tfgI eq ""} {set tfgI $tfg2}
    if {$tbgI eq ""} {set tbgI $tbg2}
    if {$tfgM in {"" -}} {set tfgM $tfg1}
    if {$tbgM eq ""} {set tbgM $tbg1}
    my Main_Style $tfg1 $tbg1 $tfg2 $tbg2 $tfgS $tbgS $tfgD $tbg1 $tfg1 $tbg2 $tbg1
    foreach arg {tfg1 tbg1 tfg2 tbg2 tfgS tbgS tfgD tbgD tcur bclr \
    thlp tfgI tbgI tfgM tbgM args} {
      if {$win eq "."} {
        set ::apave::_C_($win,$arg) [set $arg]
      }
      set ::apave::_CS_(expo,$arg) [set $arg]
    }
    # configuring themed widgets
    foreach ts {TLabel TLabelframe.Label TButton TMenubutton TCheckbutton TScale \
    TProgressbar TRadiobutton TScrollbar TSeparator TSizegrip TNotebook.Tab} {
      my Ttk_style configure $ts -font apaveFontDef
      my Ttk_style configure $ts -foreground $tfg1
      my Ttk_style configure $ts -background $tbg1
      my Ttk_style map $ts -background [list pressed $tbg1 active $tbg2 alternate $tbg2 focus $tbg2 selected $tbg2]
      my Ttk_style map $ts -foreground [list disabled $tfgD pressed $tfg1 active $tfg2 alternate $tfg2 focus $tfg2 selected $tfg2]
      my Ttk_style map $ts -bordercolor [list focus $bclr pressed $bclr]
      my Ttk_style map $ts -lightcolor [list focus $bclr]
      my Ttk_style map $ts -darkcolor [list focus $bclr]
      my Ttk_style configure $ts -fieldforeground $tfg2
      my Ttk_style configure $ts -fieldbackground $tbg2
    }
      my Ttk_style configure TMenu.Frame -foreground yellow
      my Ttk_style configure TMenu.Frame -background green
    foreach ts {TNotebook TPanedwindow TFrame} {
      my Ttk_style configure $ts -background $tbg1
    }
    foreach ts {TNotebook.Tab} {
      my Ttk_style configure $ts -font apaveFontDef
      my Ttk_style map $ts -foreground [list selected $tfgS active $tfg2]
      my Ttk_style map $ts -background [list selected $tbgS active $tbg2]
    }

    foreach ts {TEntry Treeview TSpinbox TCombobox TCombobox.Spinbox TProgressbar} {
      my Ttk_style configure $ts -font apaveFontDef
      my Ttk_style configure $ts -selectforeground $tfgS
      my Ttk_style configure $ts -selectbackground $tbgS
      my Ttk_style configure $ts -font apaveFontDef
      my Ttk_style map $ts -selectforeground [list !focus $::apave::_CS_(!FG)]
      my Ttk_style map $ts -selectbackground [list !focus $::apave::_CS_(!BG)]
      my Ttk_style configure $ts -fieldforeground $tfg2
      my Ttk_style configure $ts -fieldbackground $tbg2
      my Ttk_style configure $ts -insertcolor $tcur
      my Ttk_style map $ts -bordercolor [list focus $bclr active $bclr]
      my Ttk_style map $ts -lightcolor [list focus $bclr]
      my Ttk_style map $ts -darkcolor [list focus $bclr]
      if {$ts=="TCombobox"} {
        # combobox is sort of individual
        my Ttk_style configure $ts -foreground $tfg1
        my Ttk_style configure $ts -background $tbg1
        my Ttk_style map $ts -foreground [list readonly $tfg1]
        my Ttk_style map $ts -background [list {readonly focus} $tbg1]
        my Ttk_style map $ts -fieldbackground [list readonly $tbg1]
        my Ttk_style map $ts -background [list active $tbg2]
        option add *TCombobox*Listbox.font apaveFontDef userDefault
        foreach {i nam clr} \
        {0 back tbg1 1 fore tfg1 2 selectBack tbgS 3 selectFore tfgS} {
          option add *TCombobox*Listbox.${nam}ground [set $clr] userDefault
        }
      } else {
        my Ttk_style configure $ts -foreground $tfg2
        my Ttk_style configure $ts -background $tbg2
        my Ttk_style map $ts -foreground [list disabled $tfgD readonly $tfgD selected $tfgS]
        my Ttk_style map $ts -background [list disabled $tbgD readonly $tbgD selected $tbgS]
      }
    }
    foreach ts {TRadiobutton TCheckbutton} {
      ttk::style map $ts -background [list focus $tbg2 !focus $tbg1]
    }
    # non-themed widgets of button and entry types
    foreach ts [my NonThemedWidgets button] {
      set ::apave::_C_($ts,0) 5
      set ::apave::_C_($ts,1) "-background $tbg1"
      set ::apave::_C_($ts,2) "-foreground $tfg1"
      set ::apave::_C_($ts,3) "-activeforeground $tfg2"
      set ::apave::_C_($ts,4) "-activebackground $tbg2"
      set ::apave::_C_($ts,5) "-font apaveFontDef"
      switch -- $ts {
        checkbutton - radiobutton {
          set ::apave::_C_($ts,0) 7
          set ::apave::_C_($ts,6) "-selectcolor $tbg1"
          set ::apave::_C_($ts,7) "-highlightbackground $tbg1"
        }
        frame - scrollbar - tframe - tnotebook {
          set ::apave::_C_($ts,0) 1
        }
        menu {
          set ::apave::_C_($ts,0) 6
          set ::apave::_C_($ts,1) "-background $tbgM"
          set ::apave::_C_($ts,3) "-activeforeground $tfgS"
          set ::apave::_C_($ts,4) "-activebackground $tbgS"
          set ::apave::_C_($ts,5) "-borderwidth 2"
          set ::apave::_C_($ts,6) "-relief raised"
        }
      }
    }
    foreach ts [my NonThemedWidgets entry] {
      set ::apave::_C_($ts,0) 2
      set ::apave::_C_($ts,1) "-foreground $tfg2"
      set ::apave::_C_($ts,2) "-background $tbg2"
      switch -- $ts {
        tcombobox {
          set ::apave::_C_($ts,0) 7
          set ::apave::_C_($ts,3) "-insertbackground $tcur"
          set ::apave::_C_($ts,4) "-disabledforeground $tfgD"
          set ::apave::_C_($ts,5) "-disabledbackground $tbgD"
          set ::apave::_C_($ts,6) "-highlightcolor $bclr"
          set ::apave::_C_($ts,7) "-font apaveFontDef"
        }
        text - entry - tentry {
          set ::apave::_C_($ts,0) 9
          set ::apave::_C_($ts,3) "-insertbackground $tcur"
          set ::apave::_C_($ts,4) "-selectforeground $tfgS"
          set ::apave::_C_($ts,5) "-selectbackground $tbgS"
          set ::apave::_C_($ts,6) "-disabledforeground $tfgD"
          set ::apave::_C_($ts,7) "-disabledbackground $tbgD"
          set ::apave::_C_($ts,8) "-highlightcolor $bclr"
          if {$ts eq "text"} {
            set ::apave::_C_($ts,9) "-font apaveFontMono"
          } else {
            set ::apave::_C_($ts,9) "-font apaveFontDef"
          }
        }
        spinbox - tspinbox - listbox - tablelist {
          set ::apave::_C_($ts,0) 10
          set ::apave::_C_($ts,3) "-highlightcolor $bclr"
          set ::apave::_C_($ts,4) "-insertbackground $tcur"
          set ::apave::_C_($ts,5) "-buttonbackground $tbg2"
          set ::apave::_C_($ts,6) "-selectforeground $::apave::_CS_(!FG)" ;# $tfgS
          set ::apave::_C_($ts,7) "-selectbackground $::apave::_CS_(!BG)" ;# $tbgS
          set ::apave::_C_($ts,8) "-disabledforeground $tfgD"
          set ::apave::_C_($ts,9) "-disabledbackground $tbgD"
          set ::apave::_C_($ts,10) "-font apaveFontDef"
        }
      }
    }
    foreach ts {disabled} {
      set ::apave::_C_($ts,0) 4
      set ::apave::_C_($ts,1) "-foreground $tfgD"
      set ::apave::_C_($ts,2) "-background $tbgD"
      set ::apave::_C_($ts,3) "-disabledforeground $tfgD"
      set ::apave::_C_($ts,4) "-disabledbackground $tbgD"
    }
    foreach ts {readonly} {
      set ::apave::_C_($ts,0) 2
      set ::apave::_C_($ts,1) "-foreground $tfg1"
      set ::apave::_C_($ts,2) "-background $tbg1"
    }
    # set the new options for nested widgets (menu e.g.)
    my themeNonThemed $win
    # other options per widget type
    foreach {typ v1 v2} $args {
      if {$typ=="-"} {
        # config of non-themed widgets
        set ind [incr ::apave::_C_($v1,0)]
        set ::apave::_C_($v1,$ind) "$v2"
      } else {
        # style maps of themed widgets
        my Ttk_style map $typ $v1 [list {*}$v2]
      }
    }
    return
  }

  ###########################################################################

  method UpdateSelectAttrs {w} {

    # Updates attributes for selection.
    #   w - window's name
    # Some widgets (e.g. listbox) need a work-around to set
    # attributes for selection in run-time, namely at focusing in/out.

    if { [string first "-selectforeground" [bind $w "<FocusIn>"]] < 0} {
      set com "lassign \[::apave::parseOptions \[ttk::style configure .\] \
        -selectforeground $::apave::_CS_(!FG) \
        -selectbackground $::apave::_CS_(!BG)\] fS bS;"
      bind $w <FocusIn> "+ $com $w configure \
        -selectforeground \$fS -selectbackground \$bS"
      bind $w <FocusOut> "+ $w configure -selectforeground \
        $::apave::_CS_(!FG) -selectbackground $::apave::_CS_(!BG)"
    }
    return
  }

  ###########################################################################

  method untouchWidgets {args} {

    # Makes non-ttk widgets to be untouched by coloring
    #   args - list of widget globs (e.g. {.em.fr.win.* .em.fr.h1 .em.fr.h2})
    #
    # See also:
    #   themeNonThemed

    foreach u $args {lappend ::apave::_CS_(untouch) $u}
  }

  ###########################################################################

  method themeNonThemed {win} {

    # Updates the appearances of currently used widgets (non-themed).
    #   win - window path whose children will be touched
    #
    # See also:
    #   untouchWidgets

    set wtypes [my NonThemedWidgets all]
    foreach w1 [winfo children $win] {
      my themeNonThemed $w1
      set ts [string tolower [winfo class $w1]]
      set tch 1
      foreach u $::apave::_CS_(untouch) {
        if {[string match $u $w1]} {set tch 0; break}
      }
      if {$tch && [info exist ::apave::_C_($ts,0)] && \
      [lsearch -exact $wtypes $ts]>-1} {
        set i 0
        while {[incr i] <= $::apave::_C_($ts,0)} {
          lassign $::apave::_C_($ts,$i) opt val
          catch {
            if {[string first __tooltip__.label $w1]<0} {
              $w1 configure $opt $val
              switch -- [$w1 cget -state] {
                "disabled" {
                  $w1 configure {*}[my NonTtkStyle $w1 1]
                }
                "readonly" {
                  $w1 configure {*}[my NonTtkStyle $w1 2]
                }
              }
            }
            set nam3 [string range [my ownWName $w1] 0 2]
            if {$nam3 in {lbx tbl flb enT spX tex}} {
              my UpdateSelectAttrs $w1
            }
          }
        }
      }
    }
    return
  }

  ###########################################################################

  method NonThemedWidgets {selector} {

    # Lists the non-themed widgets to process in apave.
    #   selector - sets a widget group to return as a list
    # The `selector` can be `entry`, `button` or `all`.

    switch -- $selector {
      entry {
        return [list tspinbox tcombobox tentry entry text listbox spinbox tablelist]
      }
      button {
        return [list label button menu menubutton checkbutton radiobutton frame labelframe scale scrollbar]
      }
    }
    return [list tspinbox tcombobox tentry entry text listbox spinbox label button \
      menu menubutton checkbutton radiobutton frame labelframe scale \
      scrollbar tablelist]
  }

  ###########################################################################

  method NonTtkTheme {win} {

    # Calls themeWindow to color non-ttk widgets.
    #   win - window's name

    if {[info exists ::apave::_C_(.,tfg1)] &&
    $::apave::_CS_(expo,tfg1) ne "-"} {
      my themeWindow $win \
         $::apave::_C_(.,tfg1) \
         $::apave::_C_(.,tbg1) \
         $::apave::_C_(.,tfg2) \
         $::apave::_C_(.,tbg2) \
         $::apave::_C_(.,tfgS) \
         $::apave::_C_(.,tbgS) \
         $::apave::_C_(.,tfgD) \
         $::apave::_C_(.,tbgD) \
         $::apave::_C_(.,tcur) \
         $::apave::_C_(.,bclr) \
         $::apave::_C_(.,thlp) \
         $::apave::_C_(.,tfgI) \
         $::apave::_C_(.,tbgI) \
         $::apave::_C_(.,tfgM) \
         $::apave::_C_(.,tbgM) \
         false {*}$::apave::_C_(.,args)
    }
    return
  }

  ###########################################################################

  method NonTtkStyle {typ {dsbl 0}} {

    # Makes styling for non-ttk widgets.
    #   typ - widget's type (the same as in "APave::widgetType" method)
    #   dsbl - `1` for disabled; `2` for readonly; otherwise for all widgets
    # See also: APave::widgetType

    if {$dsbl} {
      set disopt ""
      if {$dsbl==1 && [info exist ::apave::_C_(disabled,0)]} {
        set typ [string range [lindex [split $typ .] end] 0 2]
        switch -- $typ {
          frA - lfR {
            append disopt " " $::apave::_C_(disabled,2)
          }
          enT - spX {
            append disopt " " $::apave::_C_(disabled,1) \
                          " " $::apave::_C_(disabled,2) \
                          " " $::apave::_C_(disabled,3) \
                          " " $::apave::_C_(disabled,4)
          }
          laB - tex - chB - raD - lbx - scA {
            append disopt " " $::apave::_C_(disabled,1) \
                          " " $::apave::_C_(disabled,2)
          }
        }
      } elseif {$dsbl==2 && [info exist ::apave::_C_(readonly,0)]} {
        append disopt " " \
          $::apave::_C_(readonly,1) " " $::apave::_C_(readonly,2) \
      }
      return $disopt
    }
    set opts {-foreground -foreground -background -background}
    lassign "" ts2 ts3 opts2 opts3
    switch -- $typ {
      "buT" {set ts TButton}
      "chB" {set ts TCheckbutton
        lappend opts -background -selectcolor
      }
      "enT" {
        set ts TEntry
        set opts  {-foreground -foreground -fieldbackground -background \
          -insertbackground -insertcolor}
      }
      "tex" {
        set ts TEntry
        set opts {-foreground -foreground -fieldbackground -background \
          -insertcolor -insertbackground \
          -selectforeground -selectforeground -selectbackground -selectbackground
        }
      }
      "frA" {set ts TFrame; set opts {-background -background}}
      "laB" {set ts TLabel}
      "lbx" {set ts TLabel}
      "lfR" {set ts TLabelframe}
      "raD" {set ts TRadiobutton}
      "scA" {set ts TScale}
      "sbH" -
      "sbV" {set ts TScrollbar; set opts {-background -background}}
      "spX" {set ts TSpinbox}
      default {
        return ""
      }
    }
    set att ""
    for {set i 1} {$i<=3} {incr i} {
      if {$i>1} {
        set ts [set ts$i]
        set opts [set opts$i]
      }
      foreach {opt1 opt2} $opts {
        if {[catch {set val [ttk::style configure $ts $opt1]}]} {
          return $att
        }
        if {$val==""} {
          catch { set val [ttk::style $oper . $opt2] }
        }
        if {$val!=""} {
          append att " $opt2 $val"
        }
      }
    }
    return $att
  }

# _______________________________________________________________________ #

  method ThemePopup {mnu args} {

    # Recursively configures popup menus.
    #   mnu - menu's name (path)
    #   args - options of configuration
    # See also: themePopup

    if {[set last [$mnu index end]] ne "none"} {
      $mnu configure {*}$args
      for {set i 0} {$i <= $last} {incr i} {
        switch -- [$mnu type $i] {
          "cascade" {
            my ThemePopup [$mnu entrycget $i -menu] {*}$args
          }
          "command" {
            $mnu entryconfigure $i {*}$args
          }
        }
      }
    }
  }

  ###########################################################################

  method themePopup {mnu} {

    # Configures a popup menu so that its colors accord with a current CS.
    #   mnu - menu's name (path)

    if {[my csCurrent] == $::apave::_CS_(NONCS)} return
    lassign [my csGet] - fg - - - bgS fgS - - - - - - bg
    my ThemePopup $mnu -foreground $fg -background $bg \
      -activeforeground $fgS -activebackground $bgS
  }

  ###########################################################################

  method configTooltip {fg bg args} {

    # Configurates colors and other attributes of tooltip.
    #  fg - foreground
    #  bg - background
    #  args - other attributes

    if {[info exists ::tooltip::labelOpts]} {
	    # Undocumented feature of tooltip.tcl
	    set ::tooltip::labelOpts [list -highlightthickness 1 \
        -relief solid -bd 1 -background $bg -fg $fg {*}$args]
    }
    return
  }

}

###########################################################################

  #%   DOCTEST   SOURCE   tests/obbit_1.test

################################# EOF #####################################
