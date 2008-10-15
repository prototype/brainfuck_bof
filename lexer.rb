module Brainfuck
class Lexer
	attr_reader :column
	attr_reader :line
	attr_reader :source_stream
	
	def initialize(file_path)
		@source_stream = File.new(file_path, 'r')
		@column = 1
		@line   = 1
	end
	
	def tokenize(c)
		case c
		when '<'
			return :decr_ptr
		when '>'
			return :incr_ptr
		when '+'
			return :incr_ptd_byte
		when '-'
			return :decr_ptd_byte
		when '['
			return :begin_while
		when ']'
			return :end_while
		when '.'
			return :output_ptd_byte
		when ','
			return :input_ptd_byte
		when nil
			return :eof
		else
			raise "Unknown token at line #{@line} and column #{@column}"
		end
	end
	
	def peek
		next_char = @source_stream.getc
		if next_char != nil
			@source_stream.ungetc(next_char)
			next_char = next_char.chr
		end
		return tokenize(next_char)
	end
	
	def recognize!
		consume
		return tokenize(@current_char)
	end
		
	protected
	def consume
		@current_char = @source_stream.getc
		@current_char = @current_char.chr if @current_char != nil
		
		@column += 1
		
		if @current_char == '\n'
			@column = 1
			@line  += 1
		end
		
		# This line should be here because of possible tail recursion optimization
		consume if @current_char =~ /\r/
	end
end
end