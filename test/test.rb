
#
# testing rufus-json
#
# Sat Jul 17 14:38:44 JST 2010
#

require 'rubygems'

R = `which ruby`.strip
P = File.dirname(__FILE__)

%w[ json active_support yajl json/pure ].each do |lib|
  puts
  puts '-' * 80
  puts "#{R} #{P}/do_test.rb #{lib}"
  puts `#{R} #{P}/do_test.rb #{lib}`
end

puts
puts '-' * 80
puts "#{R} #{P}/backend_test.rb"
puts `#{R} #{P}/backend_test.rb`

