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