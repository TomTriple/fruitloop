class Node

  @@target = ""

  def emit(str)
    @@target += str
  end

  def close
    p @@target 
  end
end

class NodeStart < Node
  attr_accessor :program

  def gen
    emit("(function() {")
    program.gen
    emit("})()")
    close
  end

end

class NodeAssignment < Node
  attr_accessor :lvalue, :rvalue

  def gen
    emit("var #{lvalue.name} = #{rvalue.gen};")
    emit("alert(xa);") 
  end

end

class NodeArithmetic < Node
  attr_accessor :left_op, :right_op, :op

  def gen
    return ("#{Symbols.get(left_op.name)} #{(op.op)} #{right_op.number}") 
  end

end



class Symbols
  def self.setup
    @@symbols = {}
  end
  def self.add(name, value)
    @@symbols[name] = value
  end
  def self.get(name)
    @@symbols[name] || 0 
  end
end



class Parser

  def initialize(lexer)
    @lexer = lexer
  end

  def test_tokens
    while (@token = @lexer.input_token)
      p @token
    end
  end

  def parse_start
    #test_tokens
    #exit

    @node_start = NodeStart.new 
    parse_p
    match(TTerminate)

    Symbols.setup 
    @node_start.gen

  end

  def parse_p
    @node_assignment = NodeAssignment.new
    @node_start.program = @node_assignment
    match(TIdentifier)
    @node_assignment.lvalue = @token
    parse_a
  end

  def parse_a
    match(TColon)
    parse_b
  end

  def parse_b
    match(TEq)
    parse_c 
  end

  def parse_c
    match(TIdentifier)
    @node_arithmetic = NodeArithmetic.new
    @node_assignment.rvalue = @node_arithmetic
    @node_arithmetic.left_op = @token
    parse_d
  end

  def parse_d
    match(TBinOp)
    @node_arithmetic.op = @token
    match(TNumber)
    @node_arithmetic.right_op = @token
  end


  private

  def match(which_class)
    @token = @lexer.input_token
    unless @token.is_a?(which_class)
      p "Parsing-Fehler. Is: #{@token.class}, Expected: #{which_class}"
      exit
    end
  end

end