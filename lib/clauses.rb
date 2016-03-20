require 'clause'

class Clauses
  CONJUNCT_CHAR = '∧'

  attr_reader :clauses

  def self.from_str(str)
    clauses = str.split(CONJUNCT_CHAR)
    # Strip wrapping parens
    self.new clauses.map { |clause| Clause.from_str clause.gsub(/[()]/, '') }
  end

  def initialize(clauses)
    @clauses = clauses
  end

  def symbols
    @clauses.map(&:symbols).flatten
  end

  def pure_symbols(model = {})
    unique_symbols = symbols.sort.uniq
    unique_symbols = unique_symbols.reject { |sym| model.keys.include? sym.name }
    unique_symbols.reject { |sym| unique_symbols.any? { |int_sym| sym.name == int_sym.name && sym.negated? == !int_sym.negated? } }
  end

  def units(model = {})
    clauses.select { |clause| clause.unit?(model) }
  end

  def value(model)
    vals = @clauses.map { |clause| clause.value(model) }
    return true if vals.all?
    return false if vals.any? { |val| val == false }
    nil
  end

  def to_s
    clauses.map { |clause| "(#{clause})" }.join(CONJUNCT_CHAR)
  end
end
