$:.unshift(File.join(File.dirname(__FILE__)))

require "lexer"
require "parser"

lexer = Lexer.new
parser = Parser.new(lexer)
parser.parse_start
