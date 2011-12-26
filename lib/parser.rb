class Node
  @@target = ""

  def translate(src)
    @@target += src
  end
end


class NodeStart < Node
  attr_accessor :children

  def accept(visitor)
    visitor.visitStart self
  end
end


class NodeAssignment < Node
  attr_accessor :lvalue, :rvalue

  def accept(visitor)
    visitor.visitAssignment self
  end
end


class NodeLoop < Node
  attr_accessor :to, :children

  def accept(visitor)
    visitor.visitLoop self 
  end
end









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

    parse_p
    raise parse_error unless token.is_a?TTerminate 

  end

  def parse_p
    input_token
    if token.is_a?TIdentifier
      parse_a
    elsif token.is_a?TLoop
      match TIdentifier
      match TDo
      parse_p
      raise parse_error unless token.is_a?TEnd 
    else
      raise parse_error
    end
    # 
    input_token
    if token.is_a?TSemicolon
      parse_x
    end
  end

  def parse_x
    parse_p
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
    parse_d
  end

  def parse_d
    match(TBinOp)
    match(TNumber)
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