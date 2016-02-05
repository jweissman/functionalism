require 'rspec'
require 'pry'
require 'rantly/rspec_extensions'

require 'functionalism'

include Functionalism

Rantly::Property.send(:remove_const, "VERBOSITY")
Rantly::Property.const_set("VERBOSITY", 0)

Rantly::Property.send(:remove_const, "RANTLY_COUNT")
Rantly::Property.const_set("RANTLY_COUNT", 50)


