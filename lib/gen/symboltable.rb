class SymbolTable

  @@symbols = []
  @@identifiers = []

  def self.getVar(symbol)
    @@symbols[symbol] || 0 
  end

  def self.addVar(symbol, value = 0)
    @@symbols[symbol] = value
  end

  def self.identifiers; @@identifiers; end; 



end