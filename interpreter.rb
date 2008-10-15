#!/usr/bin/env ruby
require 'lexer'
require 'parser'

module Brainfuck
class Interpreter
	def initialize(file_path)
		@file_path = file_path
		@lexer  = Lexer.new(file_path)
		@parser = Parser.new(@lexer)
		@addresses = [0] * 3000
		@ptr = 0
	end
	
	def interpret
		@parser.parse
		children = @parser.ast.children
		children.each { |child| child.accept(self) }
	end
	
	def visit_incr_ptr(ast)
		#puts 'debug: >'
		@ptr += 1
	end
	
	def visit_decr_ptr(ast)
		#puts 'debug: <'
		@ptr -= 1
	end
	
	def visit_incr_ptd_byte(ast)
		#puts 'debug: +'
		@addresses[@ptr] += 1
	end
	
	def visit_decr_ptd_byte(ast)
		#puts 'debug: -'
		@addresses[@ptr] -= 1
	end
	
	def visit_output_ptd_byte(ast)
		#puts 'debug: .'
		print @addresses[@ptr].chr
	end
	
	def visit_input_ptd_byte(ast)
		#puts 'debug: ,'
		@addresses[@ptr] = $stdin.getc
	end
	
	def visit_eof(ast)
		#done
	end
	
	def visit_while(ast)
		#print '['
		while(@addresses[@ptr] != 0)
			children = ast.children
			children.each { |child| child.accept(self) }
		end
		#print ']'
	end
end
end

interpreter = Brainfuck::Interpreter.new("hello_world.bf")
interpreter.interpret