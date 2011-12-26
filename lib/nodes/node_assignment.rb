
class NodeAssignment
  attr_accessor :lvalue, :op1, :op, :op2

  def accept(visitor)
    visitor.visitAssignment self
  end
end