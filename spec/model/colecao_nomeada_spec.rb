require 'spec_helper'

module Model
  describe ColecaoNomeada, 'dado uma classe que tenha um método nome e outra que represente uma coleção da primeira' do
    class Barbatanas
      extend ColecaoNomeada

      named_collection_of :@barbatanas

      def initialize(barbatanas=[])
        @barbatanas = barbatanas
      end
    end

    subject{Barbatanas.new}

    let(:enrugada){stub :enrugada, nome: :enrugada}
    let(:lisa){stub :lisa, nome: :lisa}

    it 'recupera-se o elemento através do seu nome' do
      barbatanas = Barbatanas.new([enrugada, lisa])

      barbatanas[:lisa].should be_equal lisa
      barbatanas[:enrugada].should be_equal enrugada
    end

    it 'inserção é feita como em uma array' do
      barbatanas = Barbatanas.new

      barbatanas << enrugada
      barbatanas << lisa

      barbatanas[:enrugada].should == enrugada
      barbatanas[:lisa].should == lisa
    end

    it 'implementa o #each normalmente' do
      barbatanas = Barbatanas.new([enrugada, lisa])

      barbatanas.each do |barbatana|
        [enrugada, lisa].should include barbatana
      end
    end

    describe "#+(coleção) uni com outra coleção" do
      before :each do
        @barbatanas_vazia = Barbatanas.new
        @enrugada = enrugada
      end

      it 'pode receber array' do
        barbatanas = @barbatanas_vazia + [@enrugada]

        barbatanas.should == Barbatanas.new([@enrugada])
        @barbatanas_vazia.should be_empty
      end

      it 'pode receber outra coleção nomeada' do
        barbatanas = @barbatanas_vazia + Barbatanas.new([@enrugada])

        barbatanas.should == Barbatanas.new([@enrugada])
        @barbatanas_vazia.should be_empty
      end

      it 'tratamento para coleções nomeadas com nomes iguais'
      it 'tratamento para arrays com elementos que não têm o método nome'
    end
  end
end
