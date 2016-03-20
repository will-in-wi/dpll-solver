require 'clause'

RSpec.describe Clause do
  let(:symbol1) { ClauseSymbol.new :A }
  let(:symbol2) { ClauseSymbol.new :B }
  let(:symbols) { [symbol1, symbol2] }
  let(:clause) { Clause.new symbols }

  describe '.from_str' do
    let(:str) { '¬A∨B∨E' }
    let(:clause) { Clause.from_str str }
    subject { clause.symbols }

    it 'is expected to have three symbols' do
      expect(subject.size).to eq 3
    end

    it 'is expected to have A' do
      expect(subject.map(&:name)).to include :A
    end

    it 'is expected to have B' do
      expect(subject.map(&:name)).to include :B
    end

    it 'is expected to have E' do
      expect(subject.map(&:name)).to include :E
    end
  end

  describe '#==' do
    let(:other_symbols) { [ClauseSymbol.new(:A), ClauseSymbol.new(:B)] }
    let(:other) { Clause.new other_symbols }
    subject { clause == other }

    it { is_expected.to eq true }

    context 'with different order' do
      let(:other_symbols) { super().reverse}
      
      it { is_expected.to eq true }
    end

    context 'with different symbols' do
      let(:other_symbols) { super() + [ClauseSymbol.new(:C)] }

      it { is_expected.to eq false }
    end
  end

  describe '#symbols' do
    subject { clause.symbols }
    it { is_expected.to eq symbols }
  end

  describe '#undef_symbols' do
    let(:model) { {} }
    subject { clause.undef_symbols(model) }
    it { is_expected.to eq symbols }

    context 'with model' do
      let(:model) { { A: true } }
      it { is_expected.to eq [symbol2] }
    end

  end

  describe '#unit?' do
    let(:model) { {} }
    subject { clause.unit?(model) }

    context 'with multiple literals' do
      it { is_expected.to eq false }
    end

    context 'with one literal' do
      let(:symbols) { [symbol1] }
      it { is_expected.to eq true }
    end

    context 'with model' do
      let(:model) { { B: true } }
      it { is_expected.to eq true }
    end

    context 'with complete model' do
      let(:model) { { A: true, B: true } }
      it { is_expected.to eq false }
    end
  end

  describe '#value' do
    let(:model) { { A: true, B: true } }
    subject { clause.value model }

    it { is_expected.to eq true }

    context 'with one true' do
      let(:model) { { A: true, B: nil } }
      it { is_expected.to eq true }
    end

    context 'with all false' do
      let(:model) { { A: false, B: false } }
      it { is_expected.to eq false }
    end

    context 'with any nil' do
      let(:model) { { A: nil, B: false} }
      it { is_expected.to eq nil }
    end
  end

  describe '#to_s' do
    let(:symbol2) { ClauseSymbol.new :B, true }
    subject { clause.to_s }
    it { is_expected.to eq 'A∨¬B' }
  end
end
