require 'spec_helper'

module Model
  describe ColecaoNomeada do
    class Barbatana
      attr_reader :nome

      def initialize(nome)
        @nome = nome
      end
    end

    class Barbatanas
      extend ColecaoNomeada

      named_collection_of Barbatana, :@barbatanas

      def initialize(barbatanas=[])
        @barbatanas = barbatanas
      end
    end

    subject{Barbatanas.new}

    it 'inserção e recuperação' do
      enrugada = Barbatana.new :enrugada
      lisa = Barbatana.new :lisa

      barbatanas = Barbatanas.new

      barbatanas << enrugada
      barbatanas << lisa

      barbatanas[:enrugada].should == enrugada
      barbatanas[:lisa].should == lisa
    end

    it 'coleção' do
      enrugada = Barbatana.new :enrugada
      lisa = Barbatana.new :lisa

      barbatanas = Barbatanas.new([enrugada, lisa])

      barbatanas.each do |barbatana|
        [enrugada, lisa].should include barbatana
      end
    end

    describe "#+(coleção)" do
      before :each do
        @barbatanas_vazia = Barbatanas.new
        @enrugada = Barbatana.new :enrugada
      end

      context 'contas como instancia de Array' do
        it 'nova coleção de contas com as contas das duas coleções' do
          barbatanas = @barbatanas_vazia + [@enrugada]

          barbatanas.should == Barbatanas.new([@enrugada])
          @barbatanas_vazia.should be_empty
        end
      end

      context 'contas como instancia de Contas' do
        it 'nova coleção de contas com as contas das duas coleções' do
          barbatanas = @barbatanas_vazia + Barbatanas.new([@enrugada])

          barbatanas.should == Barbatanas.new([@enrugada])
          @barbatanas_vazia.should be_empty
        end
      end
    end
  end
end
