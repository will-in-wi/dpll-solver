class ClauseSymbol
  NEGATION_CHAR = '¬'.freeze
  attr_reader :name

  def self.from_str(str)
    negated = (str[0] == NEGATION_CHAR)
    name_char = negated ? str[1] : str[0]
    self.new name_char.to_sym, negated
  end

  def initialize(name, negated=false)
    @name = name
    @negated = negated
  end

  def ==(other)
    name == other.name && negated? == other.negated?
  end

  def eql?(other)
    self == other
  end

  def hash
    { name => negated? }.hash
  end

  def <=>(other)
    return nil unless other.respond_to?(:name) && other.respond_to?(:negated?)

    ret = (name <=> other.name)
    return ret unless ret == 0

    if negated? && !other.negated?
      1
    elsif !negated? && other.negated?
      -1
    else
      0
    end
  end

  def negated?
    @negated
  end

  def pure?(other)
    negated? == other.negated?
  end

  def value(model)
    return if model[name].nil?
    if negated?
      !model[name]
    else
      model[name]
    end
  end

  def to_s
    res = ''
    res += NEGATION_CHAR if negated?
    res += name.to_s

    res
  end
end
