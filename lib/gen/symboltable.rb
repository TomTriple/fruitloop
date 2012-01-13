class SymbolTable

  @@symbols = {}
  @@identifiers = []

  def self.get_id(sym_or_tk)
    @@symbols[sym_or_tk.is_a?(Token) ? sym_or_tk.name : sym_or_tk]
  end

  def self.add_id token
    @@symbols[token.name] = token
  end

  def self.add_null_initializer token
    @@identifiers << token 
  end

  def self.null_initializers; @@identifiers; end; 

end