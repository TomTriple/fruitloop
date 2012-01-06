class NodeStart < ParentNode
  def accept(visitor)
    visitor.visit_start self
    stmts.each do |stmt|
      stmt.accept visitor
    end
  end
end