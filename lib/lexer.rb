class Token; end; 

class TIdentifier < Token
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

class TNumber  < Token
  attr_accessor :number 
  def initialize(number)
    @number = number
  end
end

class TBinOp < Token
  attr_accessor :op
  def initialize(op)
    @op = op
  end
end

class TColon < Token; end;
class TEq < Token; end;
class TTerminate < Token; end;
class TEnd < Token; end;
class TLoop < Token; end;
class TDo < Token; end;
class TSemicolon < Token; end;


class Lexer

  def initialize
    @source = ""
    read_input("source.loop")
    @pos = -1
  end


  def start
    puts "starting lexer..."
    while @next_token = next_token
      puts "t #{@next_token}"
    end
  end


  def input_token 
    @token_name = ""
    while (@c = next_char) && @input_finished.nil? 
      next if whitespace?

      # TIdentifer + Keywords
      if @c =~ /[a-zA-Z]/
        @token_name = @c
        while (@c = next_char) =~ /[a-zA-Z]/
          @token_name += @c
        end
        if @token_name == "loop"
          return TLoop.new
        elsif @token_name == "do"
          return TDo.new
        elsif @token_name == "end"
          return TEnd.new 
        else
          return TIdentifier.new(@token_name)
        end
      end

      # TColon
      if @c == ":"
        return TColon.new
      end

      if @c == "="
        return TEq.new
      end

      # TNumber
      if @c =~ /[0-9]/
        @token_name = @c
        while (@c = next_char) =~ /[0-9]/
          @token_name += @c
        end
        @pos -= 1
        return TNumber.new(@token_name)
      end

      # TBinOp
      if @c == "+" || @c == "-"
        return TBinOp.new(@c)
      end

      # TSemicolon 
      if @c == ";"
        return TSemicolon.new
      end

      # TEnd 
      if @c == "@"
        @input_finished = true
        return TTerminate.new
      end 
    end
  end


  private

  def whitespace?
    @c == "\t" or @c == "\n" or @c == "\r" or @c == " "
  end


  def read_input(file)
    open(file) do |f|
      f.each_line do |line|
        @source += line
      end
    end
    @source += " "
  end


  def next_char
    if @pos <= @source.length-1
      @pos += 1
      c = @source.slice(@pos, 1)
      #puts "char: #{c}"
      c
    else
      "@"
    end
  end

end

