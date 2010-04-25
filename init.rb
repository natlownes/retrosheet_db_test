require 'rubygems'
require 'ohm'
require 'digest/md5'
Dir[File.dirname(__FILE__) + "/lib/models/**"].each { |f| require f }

Ohm.connect