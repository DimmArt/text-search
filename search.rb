#!/usr/bin/env ruby
require 'optparse'
require './lib/search_index'

search_for = ''

OptionParser.new do |opts|
  opts.banner = "Usage: search.rb [options]"
  opts.on('-s', '--search STRING', 'use quotes for multi word query', String) { |val| search_for = val }
end.parse!


if search_for.empty?
  puts 'No search query provided'
  puts 'Please try search.rb -h to see the available options'
else
  puts "Looking for '#{search_for}':"
  puts SearchIndex.find(search_for)
end

