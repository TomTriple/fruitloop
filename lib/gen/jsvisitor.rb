require 'gen/symboltable'

class JSVisitor

  def initialize
    @target = ""
    @loop_counter = 0
  end

  def visitStart(node)
    SymbolTable.identifiers.each do |token|
      compile "#{token.name} = 0;"
    end
  end

  def visitAssignment(node)
    compile "#{node.lvalue.name} = #{node.op1.name} #{node.op.op} #{node.op2.number}; "
  end

  def visitLoopStart(node)
    compile "for(var _loopVar#{@loop_counter} = 0; _loopVar#{@loop_counter} < #{node.to.name}; _loopVar#{@loop_counter}++) {"
    @loop_counter += 1
  end

  def visitLoopEnd(node)
    compile "}"
  end

  def close 
    compile "alert(xa);"
    open("loop.js", "w").write(@target)
  end


  private

  def compile(source)
    p source 
    @target += source 
  end

end