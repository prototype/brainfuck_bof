require 'lexer'

module Brainfuck
class ParseTreeNode
	attr_accessor :token
	attr_accessor :parent
	attr_accessor :children

	def initialize(token = :start, parent = nil, children = [])
		@token    = token
		@parent   = parent
		@children = children
	end

	def accept(visitor)
		visitor.send("visit_#{@token}", self)
	end
end
	
class Parser
	attr_accessor :ast
	
	def initialize(lexer)
		@ast   = ParseTreeNode.new
		@lexer = lexer
	end
	
	def parse
		# Start parsing start symbol
		parse_statements(@ast)
	end
	
	def parse_statements(parent)
		begin
			token = @lexer.peek
			if token == :begin_while
				parse_while(parent)
			elsif token == :end_while
				return
			else
				# Parse terminal statements
				parse_terminal_statement(parent)
			end
		end while(token != :eof)
	end
	
	def parse_terminal_statement(parent)
		token = @lexer.recognize!
		#puts token.to_s
		parent.children << ParseTreeNode.new(token, parent, nil)
	end
	
	def parse_while(parent)
		expect(:begin_while)
		while_node = ParseTreeNode.new(:while, parent)
		parse_statements(while_node)
		parent.children << while_node
		expect(:end_while)
	end
	
	def expect(sym)
		token = @lexer.recognize!
		raise "Unexpected '#{token}' at line #{@lexer.line} on column #{@lexer.column}" if token != sym
	end
	
end
end