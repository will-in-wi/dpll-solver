require 'clauses'
require 'clause'
require 'clause_symbol'

RSpec.describe Clauses do
  let(:symbol1) { ClauseSymbol.new :A }
  let(:symbol2) { ClauseSymbol.new :B }
  let(:symbol3) { ClauseSymbol.new :C }
  let(:symbol4) { ClauseSymbol.new :D }
  let(:clause1) { Clause.new [symbol1, symbol2] }
  let(:clause2) { Clause.new [symbol3, symbol4] }
  let(:clause_array) { [clause1, clause2] }
  let(:clauses) { Clauses.new clause_array }

  describe '.from_str' do
    let(:str) { '(¬A∨B∨E)∧(¬B∨A)' }
    let(:clauses) { Clauses.from_str str }

    it 'is expected to have two clauses' do
      expect(clauses.clauses.size).to eq 2
    end
  end

  describe '#clauses' do
    subject { clauses.clauses }
    it { is_expected.to eq clause_array }
  end

  describe '#symbols' do
    subject { clauses.symbols }

    it { is_expected.to eq [symbol1, symbol2, symbol3, symbol4] }
  end

  describe '#value' do
    let(:model) { { A: true, B: true, C: true, D: true } }
    subject { clauses.value(model) }

    it { is_expected.to eq true }

    context 'with any false clauses' do
      let(:model) { { A: false, B: false, C: true, D: true } }
      it { is_expected.to eq false }
    end

    context 'with all true clauses' do
      it { is_expected.to eq true }
    end


    context 'with all true or nil' do
      let(:model) { { A: nil, B: false, C: true, D: true } }
      it { is_expected.to eq nil }
    end
  end

  describe '#pure_symbols' do
    # Defined as a symbol which only appears in the same negated or unnegated form.
    # Ignores symbols which have been defined in the model.
    let(:model) { {} }
    let(:symbol3) { ClauseSymbol.new :A }
    let(:symbol4) { ClauseSymbol.new :B, true }
    let(:symbol5) { ClauseSymbol.new :C }
    let(:clause2) { Clause.new [symbol3, symbol4, symbol5] }
    subject { clauses.pure_symbols(model) }

    it { is_expected.to eq [symbol3, symbol5] }

    context 'with set model' do
      let(:model) { { C: true } }
      it { is_expected.to eq [symbol3] }
    end
  end

  describe '#units' do
    let(:model) { {} }
    subject { clauses.units(model) }

    it { is_expected.to eq [] }

    context 'with unit clause' do
      let(:clause3) { Clause.new [ClauseSymbol.new(:G)] }
      let(:clause4) { Clause.new [ClauseSymbol.new(:H)] }
      let(:clause_array) { [clause1, clause2, clause3, clause4] }
      it { is_expected.to eq [clause3, clause4] }

      context 'with model' do
        let(:model) { { H: true } }
        it { is_expected.to eq [clause3] }
      end
    end
  end

  describe '#to_s' do
    let(:symbol2) { ClauseSymbol.new :B, true }
    subject { clauses.to_s }
    it { is_expected.to eq '(A∨¬B)∧(C∨D)' }
  end
end
