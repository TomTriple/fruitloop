require "nodes/node_parent"
require "nodes/node_assignment"
require "nodes/node_loop"
require "nodes/node_start"
require "gen/jsvisitor"



class Parser

  attr_reader :lookahead

  def initialize(lexer)
    @lexer = lexer
  end

  def test_tokens
    while @token = @lexer.input_token
      p @token
      break if @token.is_a?TTerminate 
    end
  end


  def parse_start
    consume_token
    case lookahead 
      when TIdentifier, TLoop then
        parse_p
        match TTerminate 
      else
        parse_error
    end
  end


  def parse_p
    case lookahead
      when TIdentifier then
        match TIdentifier
        parse_a
        parse_x
      when TLoop then
        match TLoop
        match TIdentifier
        match TDo
        parse_p
        match TEnd
        parse_x
      else
        parse_error
    end
  end

  # x kann nach Epsilon abgeleitet werden, daher...
  def parse_x
    case lookahead
      when TSemicolon then # ... neben dem fall, dass es nicht Epsilon ist...
        match TSemicolon
        parse_p
        parse_x
      when TTerminate, TEnd, TSemicolon then # ... auch auf follow-menge "predicten".
        # Epsilon-Produktion 
      else
        parse_error # fehler - da aktueller token weder in first(x) noch follow(x) 
    end
  end


  def parse_a
    case lookahead
      when TColon then
        match TColon
        parse_b
      else
        parse_error
    end
  end


  def parse_b
    case lookahead
      when TEq then
        match TEq
        parse_c
      else
        parse_error
    end
  end


  def parse_c
    case lookahead
      when TIdentifier
        match TIdentifier
        parse_d
      else
        parse_error
    end
  end


  def parse_d
    case lookahead
      when TBinOp then
        match TBinOp
        match TNumber
      else
        parse_error
    end
  end


  private

  def match(which_class)
    if lookahead.is_a?(which_class)
      p "Is: #{lookahead.class}, Expected: #{which_class}"
    else
      p "Parsing-Fehler. Is: #{lookahead.class}, Expected: #{which_class}"
      exit
    end
    consume_token
  end

  def consume_token
    @lookahead = @lexer.input_token 
    @lookahead 
  end

  def parse_error
    p "Syntaxfehler, Token is: #{lookahead.class}."
    exit 
  end

  def traverse_ast
    #visitor = JSVisitor.new
    #@node_start.accept visitor
    #visitor.run
  end


end