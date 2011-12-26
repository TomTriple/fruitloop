require "nodes/node_parent"
require "nodes/node_assignment"
require "nodes/node_loop"
require "nodes/node_start"
require "gen/jsvisitor"



class Parser

  attr_reader :token 

  def initialize(lexer)
    @lexer = lexer
  end

  def test_tokens
    while @token = @lexer.input_token
      p @token
    end
  end

  def parse_start
    #test_tokens
    #exit

    @node_start = NodeStart.new
    parse_p(@node_start)
    raise parse_error unless token.is_a?TTerminate

    visitor = JSVisitor.new
    @node_start.accept visitor
    visitor.close 
  end

  def parse_p(parent_node)
    input_token
    if token.is_a?TIdentifier
      @node_assignment = NodeAssignment.new
      @node_assignment.lvalue = token
      parse_a
      parent_node << @node_assignment
    elsif token.is_a?TLoop
      @node_loop = NodeLoop.new
      parent_node << @node_loop 
      match TIdentifier
      @node_loop.to = token
      match TDo
      parse_p(@node_loop)
      raise parse_error unless token.is_a?TEnd 
    else
      raise parse_error
    end
    # 
    input_token
    if token.is_a?TSemicolon
      parse_x(parent_node)
    end
  end

  def parse_x(parent_node)
    parse_p(parent_node) 
  end

  def parse_a
    match TColon
    parse_b
  end

  def parse_b
    match TEq
    parse_c 
  end

  def parse_c
    match TIdentifier
    SymbolTable.identifiers << token 
    @node_assignment.op1 = token
    parse_d
  end

  def parse_d
    match(TBinOp)
    @node_assignment.op = token
    match(TNumber)
    @node_assignment.op2 = token 
  end


  private

  def match(which_class)
    @token = @lexer.input_token
    unless @token.is_a?(which_class)
      p "Parsing-Fehler. Is: #{@token.class}, Expected: #{which_class}"
      exit
    end
  end

  def input_token
    @token = @lexer.input_token 
  end

  def parse_error
    "Syntaxfehler, Token is: #{@token.class}."
  end


end