require 'rubygems'
require 'ohm'
Dir[File.dirname(__FILE__) + "/lib/models/**"].each { |f| require f }

Ohm.connect