###########################################################################
#
# This script contains testing samples for the ObjectProperty class that
# allows to mix-in into a class/object the getter and setter of properties.
#
###########################################################################

source [file join [file dirname $::argv0] .. obbit.tcl]

oo::class create SomeClass {
  mixin ObjectProperty
  variable _Object_Properties
  method summary {} {
    puts "Instances: [set obj [info class instances SomeClass]]"
    puts "Namespace: [info object namespace $obj]"
    puts "Namespace: [namespace current]"
    puts "Variables: [info vars]"
    set iter [array startsearch _Object_Properties]
    while {[array anymore _Object_Properties $iter]} {
      set el [array nextelement _Object_Properties $iter]
      puts "Value of $el"
      puts "      is $_Object_Properties($el)"
    }
  }
}

SomeClass create someobj

set prop1 "Property1"
set prop2 "Property2"

# get default property
puts $prop1=[someobj get $prop1 ???]

# set ang get property
someobj set $prop1 100
puts $prop1=[someobj get $prop1 ???]

# get default 2nd property
puts $prop2=[someobj get $prop2 !!!]

# set ang get 2nd property
someobj set $prop2 200
puts $prop2=[someobj get $prop2 !!!]

# get a property by 'set prop'
puts $prop2=[someobj set $prop2]
# set a property by 'set prop val'
puts $prop2=[someobj set $prop2 300]

# set another property
someobj set someprop "someval"

# put out a summary
puts "-----------------------------"
someobj summary
puts "-----------------------------"

puts "\nBelow should be an error: 'obj set' need 1 or 2 args:\n"
puts $prop2=[someobj set $prop1 2 3]

# unreachable code
SomeClass destroy

