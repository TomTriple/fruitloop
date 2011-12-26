class NodeStart < ParentNode
  def accept(visitor)
    visitor.visitStart self
    stmts.each do |stmt|
      stmt.accept(visitor)
    end
  end
end