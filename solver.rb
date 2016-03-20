require 'clauses'
require 'clause'
require 'clause_symbol'

s = '(¬A∨B∨E)∧(¬B∨A)∧(¬E∨A)∧(¬E∨D)∧(¬C∨¬F∨¬B)∧(¬E∨B)∧(¬B∨F)∧(¬B∨C)'

def dpll_satisfiable?(sentence)
  clauses = Clauses.from_str sentence
  puts "Checking satifiability on the following sentence: #{clauses.to_s}"
  dpll(clauses, clauses.symbols, {})
end

def dpll(clauses, symbols, model)
  puts "Calling dpll() again with the following model: #{model}"

  return true if clauses.value(model) == true
  return false if clauses.value(model) == false

  p = clauses.pure_symbols(model).first
  if p
    puts "Chose pure symbol #{p}"
    return dpll(clauses, symbols - [p], model.merge({ p.name => !p.negated? }))
  end

  c = clauses.units(model).first
  if c
    puts "Chose unit clause #{c}"
    p = c.undef_symbols(model)[0]
    puts "Chose unit symbol #{p}"
    return dpll(clauses, symbols - [p], model.merge({ p.name => !p.negated? }))
  end

  p = symbols.first
  rest = symbols - [p]
  puts "Falling through to search"
  return dpll(clauses, rest, model.merge({ p.name => true })) || dpll(clauses, rest, model.merge({ p.name => false }))
end

if dpll_satisfiable? s
  puts 'This is satisfiable.'
else
  puts 'This is not satisfiable.'
end
