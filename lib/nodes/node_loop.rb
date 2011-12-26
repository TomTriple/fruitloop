class NodeLoop < ParentNode
  attr_accessor :to

  def accept(visitor)
    visitor.visitLoopStart self
    stmts.each do |stmt|
      stmt.accept visitor
    end
    visitor.visitLoopEnd self
  end
end