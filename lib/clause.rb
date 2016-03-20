require 'clause_symbol'

class Clause
  DISJUNCT_CHAR = '∨'

  attr_reader :symbols

  def self.from_str(str)
    self.new str.split(DISJUNCT_CHAR).map { |sym| ClauseSymbol.from_str sym }
  end

  def initialize(symbols)
    @symbols = symbols
  end

  def undef_symbols(model = {})
    symbols.reject { |sym| model.keys.include? sym.name }
  end

  def ==(other)
    symbols.sort == other.symbols.sort
  end

  def unit?(model = {})
    undef_symbols(model).size == 1
  end

  def value(model)
    vals = @symbols.map { |sym| sym.value(model) }
    # True when any of the symbols are true.
    return true if vals.any?
    # False when all of the symbols are false.
    return false if vals.all? { |val| val == false }
    # Nil when none are true and not all are false.
    nil
  end

  def to_s
    symbols.map(&:to_s).join(DISJUNCT_CHAR)
  end
end
