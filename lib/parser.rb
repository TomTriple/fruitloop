require "nodes/node_parent"
require "nodes/node_assignment"
require "nodes/node_loop"
require "nodes/node_start"
require "gen/jsvisitor"



class Parser

  attr_reader :lookahead

  def initialize(lexer)
    @lexer = lexer
  end

  def test_tokens
    while @token = @lexer.input_token
      p @token
      break if @token.is_a?TTerminate 
    end
  end

  # Parse-Methode für die Startproduktion
  def parse_start
    consume_token
    case lookahead 
      when TIdentifier, TLoop then
        @node_start = NodeStart.new # Startknoten des AST
        parse_p @node_start
        match TTerminate 
      else
        parse_error
    end

    # Nachdem die Syntax OK ist den AST traversieren
    traverse_ast 
  end


  def parse_p parent_node
    case lookahead
      when TIdentifier then
        @node_assignment = NodeAssignment.new
        @node_assignment.lvalue = lookahead
        SymbolTable.add_id lookahead 
        parent_node << @node_assignment # Zuweisungsknoten
        match TIdentifier
        parse_a
        parse_x parent_node
      when TLoop then
        @node_loop = NodeLoop.new
        parent_node << @node_loop # Loopknoten
        match TLoop
        to = lookahead
        semantic_error "loop variable must be defined" unless SymbolTable.get_id(to) 
        @node_loop.to = to 
        match TIdentifier
        match TDo
        parse_p @node_loop 
        match TEnd
        parse_x parent_node 
      else
        parse_error
    end
  end


  # x kann nach Epsilon abgeleitet werden, daher...
  def parse_x parent_node
    case lookahead
      when TSemicolon then # ... neben dem Fall, dass es nicht Epsilon ist...
        match TSemicolon
        parse_p parent_node
        parse_x parent_node 
      when TTerminate, TEnd, TSemicolon then # ... auch auf Follow-Menge "predicten".
        # Epsilon-Produktion 
      else
      # Fehler - da aktueller Lookahead weder in
      # 1. First(x)
      # 2. Follow(x) falls Epsilon in First(x)
      parse_error 
    end
  end


  def parse_a
    case lookahead
      when TColon then
        match TColon
        parse_b
      else
        parse_error
    end
  end


  def parse_b
    case lookahead
      when TEq then
        match TEq
        parse_c
      else
        parse_error
    end
  end


  def parse_c
    case lookahead
      when TIdentifier
        SymbolTable.add_null_initializer lookahead
        @node_assignment.op1 = lookahead # Erster Operator einer Zuweisung
        match TIdentifier
        parse_d
      when TNumber
        @node_assignment.rvalue = lookahead # Kurzzuweisung 
        match TNumber
      else
        parse_error
    end
  end


  def parse_d
    case lookahead
      when TBinOp then
        @node_assignment.op = lookahead # Operand
        match TBinOp
        @node_assignment.op2 = lookahead # Zweiter Operator einer Zuweisung
        match TNumber
      else
        parse_error
    end
  end


  private

  # Prüft ob das aktuelle Token eine Instanz von <which_class> ist, ansonsten
  # terminiert das Programm da ein Syntaxfehler vorliegt. Liest nach Prüfung das
  # nächste Token
  def match(which_class)
    if lookahead.is_a?(which_class)
      #p "Is: #{lookahead.class}, Expected: #{which_class}"
    else
      p "Syntaxfehler! Is: #{lookahead.class} Expected: #{which_class}" 
      exit
    end
    consume_token
  end

  # Holt das nächste Token vom Scanner
  def consume_token
    @lookahead = @lexer.input_token 
    @lookahead 
  end

  def parse_error
    p "Syntax error: #{lookahead.class}"
    exit 
  end

  def semantic_error(message)
    p "Semantic error: #{message}"
    exit 
  end

  def traverse_ast
    visitor = JSVisitor.new
    @node_start.accept visitor
    visitor.run
  end


end