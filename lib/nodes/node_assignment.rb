
class NodeAssignment
  
  attr_accessor :lvalue # will always be present with either...
  attr_accessor :op1, :op, :op2 # ... formal correct version or... 
  attr_accessor :rvalue # ... the normal version :) 

  def accept(visitor)
    visitor.visit_assignment self
  end
end