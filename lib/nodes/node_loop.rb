class NodeLoop < ParentNode
  attr_accessor :to

  def accept(visitor)
    visitor.visit_loop_start self
    stmts.each do |stmt|
      stmt.accept visitor
    end
    visitor.visit_loop_end self
  end
end