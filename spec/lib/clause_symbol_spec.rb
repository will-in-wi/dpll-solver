require 'clause_symbol'

RSpec.describe ClauseSymbol do
  let(:name) { :A }
  let(:negated) { false }
  let(:clause_symbol) { ClauseSymbol.new name, negated }

  describe '.from_str' do
    let(:str) { 'A' }
    let(:clause_symbol) { ClauseSymbol.from_str str }

    it 'is not negated' do
      expect(clause_symbol.negated?).to eq false
    end

    it 'is :A' do
      expect(clause_symbol.name).to eq :A
    end

    context 'with negated string' do
      let(:str) { '¬A' }

      it 'is negated' do
        expect(clause_symbol.negated?).to eq true
      end

      it 'is :A' do
        expect(clause_symbol.name).to eq :A
      end
    end
  end

  describe '#==' do
    let(:other) { ClauseSymbol.new :A, false }
    subject { clause_symbol == other }

    it { is_expected.to eq true }

    context 'with same name different negation' do
      let(:negated) { true }

      it { is_expected.to eq false }
    end

    context 'with different name same negation' do
      let(:name) { :B }

      it { is_expected.to eq false }
    end
  end

  describe '#<=>' do
    let(:other_negation) { false }
    let(:other) { ClauseSymbol.new :B, other_negation }
    subject { clause_symbol <=> other }

    it { is_expected.to eq -1 }

    context 'with name greater than' do
      let(:name) { :C }

      it { is_expected.to eq 1 }
    end

    context 'with same name but greater than negation' do
      let(:negated) { true }
      let(:name) { :B }

      it { is_expected.to eq 1 }
    end

    context 'with same name but less than negation' do
      let(:name) { :B }
      let(:other_negation) { true }

      it { is_expected.to eq -1 }
    end

    context 'with same name and negation' do
      let(:name) { :B }

      it { is_expected.to eq 0 }
    end
  end

  describe '#name' do
    subject { clause_symbol.name }

    it { is_expected.to eq :A }
  end

  describe '#negated?' do
    subject { clause_symbol.negated? }

    it { is_expected.to eq false }
  end

  describe '#pure?' do
    let(:other) { ClauseSymbol.new :B, false }
    subject { clause_symbol.pure? other }

    context 'with the same negation' do
      it { is_expected.to eq true }
    end

    context 'with different negation' do
      let(:negated) { true }
      it { is_expected.to eq false }
    end
  end

  describe 'value' do
    let(:model) { { A: true } }
    subject { clause_symbol.value model }

    it { is_expected.to eq true }

    context 'with false model' do
      let(:model) { { A: false } }
      it { is_expected.to eq false }
    end

    context 'with nil model' do
      let(:model) { {} }
      # nil indicates undefined.
      it { is_expected.to eq nil }
    end

    context 'with negated symbol' do
      let(:negated) { true }
      it { is_expected.to eq false }

      context 'with false model' do
        let(:model) { { A: false } }
        it { is_expected.to eq true }
      end

      context 'with nil model' do
        let(:model) { {} }
        # nil indicates undefined.
        it { is_expected.to eq nil }
      end
    end
  end

  describe '#to_s' do
    subject { clause_symbol.to_s }

    it { is_expected.to eq 'A' }

    context 'with negation' do
      let(:negated) { true }
      it { is_expected.to eq '¬A' }
    end
  end
end
