#!/usr/bin/env ruby
require 'optparse'
require './lib/index_file_parser'

#####################
file = ''

OptionParser.new do |opts|
  opts.banner = "Usage: index.rb [options]"
  opts.on('-f', '--file PATH', 'File path')   { |val| file = val }
end.parse!

if file.empty?
  puts 'No file to parse provided'
else
  if !File.exist?(file)
    puts "File `#{file}` doesn\'t exist"
  else
    puts "Starting parsing file `#{file}`:"
    IndexFileParser.process_file(file)
  end
end

# puts options
# words = parse_file(options[:file_path])
#
# if words.size > 0
#   words.each do |word|
#     if word.size > 1
#       add_index(word, options[:file_path])
#     end
#   end
# end
