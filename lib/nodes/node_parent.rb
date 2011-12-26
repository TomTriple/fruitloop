class ParentNode

  attr_accessor :stmts

  def initialize
    @stmts = []
  end

  def <<(it)
    @stmts << it
  end
end