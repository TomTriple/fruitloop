require "token/all"


class Lexer

  attr_accessor :lexem, :char, :state

  def initialize 
    @source = ""
    read_input(ARGV.first)
    @pos = -1
  end

  
  def input_token

    self.state = :start
    next_char

    while true

      # puts "state: #{state}, char: #{char}, lexem: #{lexem}"

      case state
        when :start then
          case char
            when ":" then self.state = :colon
            when "=" then self.state = :eq
            when /[+|-]/ then self.state = :binop
            when ";" then self.state = :semicolon
            when "@" then self.state = :terminate
            when /[a-z]/ then
              self.lexem = char
              self.state = :identifier_start
            when /[0-9]/ then
              self.lexem = char
              self.state = :number_start
            else next_char
          end
        when :colon then return TColon.new
        when :eq then return TEq.new
        when :binop then return TBinOp.new(char)
        when :semicolon then return TSemicolon.new
        when :identifier_start then
          if next_char =~ /[a-z]/
            self.lexem += char
          else
            self.state = :identifier
            @pos -= 1
          end
        when :identifier then
            l = get_and_clear_lexem
            return case l
              when "loop" then TLoop.new
              when "do" then TDo.new
              when "end" then TEnd.new
              else TIdentifier.new(l)
            end
        when :number_start then
          if next_char =~ /[0-9]/ then
            self.lexem += char
          else
            @pos -= 1
            self.state = :number 
          end
        when :number then
          l = get_and_clear_lexem
          return TNumber.new(l)
        when :terminate then return TTerminate.new
      end
    end
  end


  private

  def get_and_clear_lexem
    lex = self.lexem 
    self.lexem = ""
    lex 
  end

  def char; return @c; end;

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
      @c = @source.slice(@pos, 1)
      #puts "char: #{c}"
    else
      @c = "@"
    end
    @c 
  end

end

