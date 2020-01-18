###########################################################################
#
# This script contains testing samples for the ObjectProperty class that
# allows to mix-in into a class/object the getter and setter of properties.
#
###########################################################################

lappend auto_path ".."; package require apave

oo::class create SomeClass {
  mixin apave::ObjectProperty
  variable _OP_Properties
  method summary {} {
    puts "Instances: [set obj [info class instances SomeClass]]"
    puts "Namespace: [info object namespace $obj]"
    puts "Namespace: [namespace current]"
    puts "Variables: [info vars]"
    set iter [array startsearch _OP_Properties]
    while {[array anymore _OP_Properties $iter]} {
      set el [array nextelement _OP_Properties $iter]
      puts "Value of $el"
      puts "      is $_OP_Properties($el)"
    }
  }
}

SomeClass create someobj

set prop1 "Property1"
set prop2 "Property2"

# get default property
puts $prop1=[someobj getProperty $prop1 ???]

# set ang get property
someobj setProperty $prop1 100
puts $prop1=[someobj getProperty $prop1 ???]

# get default 2nd property
puts $prop2=[someobj getProperty $prop2 !!!]

# set ang get 2nd property
someobj setProperty $prop2 200
puts $prop2=[someobj getProperty $prop2 !!!]

# get a property by 'set prop'
puts $prop2=[someobj setProperty $prop2]
# set a property by 'set prop val'
puts $prop2=[someobj setProperty $prop2 300]

# set another property
someobj setProperty someprop "someval"

# put out a summary
puts "-----------------------------"
someobj summary
puts "-----------------------------"

puts "\nBelow should be an error: 'obj setProperty' need 1 or 2 args:\n"
puts $prop2=[someobj setProperty $prop1 2 3]

# unreachable code
SomeClass destroy
