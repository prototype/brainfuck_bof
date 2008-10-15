#!/usr/bin/env ruby
require 'lexer'
require 'parser'

module Brainfuck
class RubyCodeGenerator
	def initialize(file_path)
		@file_path = file_path
		@lexer  = Lexer.new(file_path)
		@parser = Parser.new(@lexer)
	end
	
	def emit
		puts "addresses = [0] * 3000"
		puts "ptr = 0"
		@parser.parse
		children = @parser.ast.children
		children.each { |child| child.accept(self) }
	end
	
	def visit_incr_ptr(ast)
		#puts 'debug: >'
		puts "ptr += 1"
	end
	
	def visit_decr_ptr(ast)
		#puts 'debug: <'
		puts "ptr -= 1"
	end
	
	def visit_incr_ptd_byte(ast)
		#puts 'debug: +'
		puts "addresses[ptr] += 1"
	end
	
	def visit_decr_ptd_byte(ast)
		#puts 'debug: -'
		puts "addresses[ptr] -= 1"
	end
	
	def visit_output_ptd_byte(ast)
		#puts 'debug: .'
		puts "print addresses[ptr].chr"
	end
	
	def visit_input_ptd_byte(ast)
		#puts 'debug: ,'
		puts "addresses[ptr] = $stdin.getc"
	end
	
	def visit_eof(ast)
		puts "puts"
	end
	
	def visit_while(ast)
		#print '['
		puts "while(addresses[ptr] != 0)"
			children = ast.children
			children.each { |child| child.accept(self) }
		puts "end"
		#print ']'
	end
end
end

file_path = ARGV[0]
generator = Brainfuck::RubyCodeGenerator.new(file_path)
generator.emit