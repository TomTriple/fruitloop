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
        @node_start = NodeStart.new
        parse_p @node_start
        match TTerminate 
      else
        parse_error
    end

    # syntax was ok... then: 
    traverse_ast 
  end


  def parse_p parent_node
    case lookahead
      when TIdentifier then
        @node_assignment = NodeAssignment.new
        @node_assignment.lvalue = lookahead
        parent_node << @node_assignment
        match TIdentifier
        parse_a
        parse_x parent_node
      when TLoop then
        @node_loop = NodeLoop.new
        parent_node << @node_loop
        match TLoop
        @node_loop.to = lookahead
        match TIdentifier
        match TDo
        parse_p @node_loop 
        match TEnd
        parse_x @node_loop
      else
        parse_error
    end
  end

  # x kann nach Epsilon abgeleitet werden, daher...
  def parse_x parent_node
    case lookahead
      when TSemicolon then # ... neben dem fall, dass es nicht Epsilon ist...
        match TSemicolon
        parse_p parent_node
        parse_x parent_node 
      when TTerminate, TEnd, TSemicolon then # ... auch auf follow-menge "predicten".
        # Epsilon-Produktion 
      else
        parse_error # fehler - da aktueller token weder in 1. first(x) 2. follow(x) falls Eps. in first(x)
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
        SymbolTable.identifiers << lookahead
        @node_assignment.op1 = lookahead
        match TIdentifier
        parse_d
      else
        parse_error
    end
  end


  def parse_d
    case lookahead
      when TBinOp then
        @node_assignment.op = lookahead
        match TBinOp
        @node_assignment.op2 = lookahead 
        match TNumber
      else
        parse_error
    end
  end


  private

  def match(which_class)
    if lookahead.is_a?(which_class)
      #p "Is: #{lookahead.class}, Expected: #{which_class}"
    else
      p "Syntaxfehler! Is: #{lookahead.class} Expected: #{which_class}" 
      exit
    end
    consume_token
  end

  def consume_token
    @lookahead = @lexer.input_token 
    @lookahead 
  end

  def parse_error
    p "Syntaxfehler bei Token: #{lookahead.class}"
    exit 
  end

  def traverse_ast
    visitor = JSVisitor.new
    @node_start.accept visitor
    visitor.run
  end


end