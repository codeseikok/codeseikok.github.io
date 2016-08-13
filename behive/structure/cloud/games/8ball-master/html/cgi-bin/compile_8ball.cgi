#!/usr/bin/env jruby

require 'cgi'
require '../8ball'

cgi = CGI.new
code = cgi['code']

puts "Content-type: text/plain"
puts ""

class EightBallCompiler
	def self.cs(ruby)
		ast = parse(ruby)
   		puts ast.accept(EightBallVisitor.new)
	end
end

begin 
	EightBallCompiler.cs(code)
rescue => e
	puts e.inspect
	puts e.backtrace
end