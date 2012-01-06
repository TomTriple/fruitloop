require 'gen/symboltable'

class JSVisitor

  def initialize
    @target = ""
    @loop_counter = 0
  end

  def visit_start(node)
    compile "var sys = require('sys');"
    SymbolTable.identifiers.each do |token|
      compile "#{token.name} = 0;"
    end
  end

  def visit_assignment(node)
    compile "#{node.lvalue.name} = #{node.op1.name} #{node.op.op} #{node.op2.number}; "
  end

  def visit_loop_start(node)
    compile "_loopTerminate#{@loop_counter} = #{node.to.name};"
    compile "for(var _loopVar#{@loop_counter} = 0; _loopVar#{@loop_counter} < _loopTerminate#{@loop_counter}; _loopVar#{@loop_counter}++) {"
    @loop_counter += 1
  end

  def visit_loop_end(node)
    compile "}"
  end

  def run
    compile "sys.puts(\"xa = \" + xa);" 
    nodejs = IO.popen("/usr/local/bin/node", "r+")
    nodejs.puts @target
    nodejs.close_write
    puts nodejs.gets 
  end


  private

  def compile(source)
    #p source
    @target += "#{source}"
  end

end