require 'rubygems'
require 'set'
require 'ohm'
require 'digest/md5'
require 'facets'
require 'json'
require 'active_support'
models = File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'models')
$LOAD_PATH.unshift(models)

Ohm.connect
