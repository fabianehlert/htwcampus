#!/usr/local/bin/ruby

if ARGV[0] == nil
	puts 'Specify input file!'
	exit 1
end

puts "// This file is generated, do not change by hand!\n"
puts "import Foundation\n\n"
puts "enum Loca {\n"

File.open(ARGV[0]).each do |line|

	next if !/\".*\"\s*=\s*\".*\";/.match(line)

	key = line[/\"(.*)\"\s*=\s*\".*\";/, 1]
	value = line[/\".*\"\s*=\s*\"(.*)\";/, 1]

	puts "\t// #{value}\n"
	puts "\tstatic var #{key}: String { return NSLocalizedString(\"#{key}\", comment: \"\") }\n"
end

puts "}\n"
