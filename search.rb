#!/usr/bin/env ruby
require 'optparse'
require './lib/search_index'

search_for = ''

OptionParser.new do |opts|
  opts.banner = "Usage: search.rb [options]"
  opts.on('-s', '--search STRING', '"Search string"', String) { |val| search_for = val }
end.parse!


puts "Looking for '#{search_for}':"
puts SearchIndex.find(search_for)