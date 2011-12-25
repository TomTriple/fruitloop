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
    token.is_a? TTerminate

  end

  def parse_p
    input_token
    if token.is_a? TIdentifier
      parse_a
      parse_x
    elsif token.is_a? TLoop
      match TIdentifier
      match TDo
      parse_p
      token.is_a? TEnd
      parse_x
    else
      puts "Syntaxfehler (Semicolon am Ende?)"
    end
  end

  def parse_x
    input_token
    if token.is_a? TSemicolon
      parse_p
      parse_x
    else

    end
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


end