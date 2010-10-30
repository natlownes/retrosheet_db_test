require 'rubygems'
require 'set'
require 'ohm'
require 'digest/md5'
require 'facets'
require 'json'
require 'activesupport'
Dir[File.dirname(__FILE__) + "/lib/models/**"].each { |f| require f }

Ohm.connect
