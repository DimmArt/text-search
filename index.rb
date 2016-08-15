#!/usr/bin/env ruby
require 'optparse'
require './lib/index_file_parser'

#####################
file = ''

OptionParser.new do |opts|
  opts.banner = "Usage: index.rb [options]"
  opts.on('-f', '--file PATH', 'File name')   { |val| file = val }
end.parse!

if file.empty?
  puts 'No file to parse provided'
  puts 'Please try index.rb -h to see the available options'
else
  if !File.exist?(file)
    puts "File `#{file}` doesn\'t exist"
  else
    puts "Starting parsing file `#{file}`:"
    IndexFileParser.process_file(file)
  end
end
