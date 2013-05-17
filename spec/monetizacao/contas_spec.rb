# encoding: utf-8
require 'spec_helper'

module Monetizacao
  describe Contas do
    it 'inserção e recuperação' do
      cofre = build(:conta, nome: :cofre)
      doacoes = build(:conta, nome: :doacoes)

      contas = build(:contas)

      contas << cofre
      contas << doacoes

      contas[:cofre].should == cofre
      contas[:doacoes].should == doacoes
    end

    it 'coleção' do
      cofre = build(:conta, nome: :cofre)
      doacoes = build(:conta, nome: :doacoes)

      contas = build(:contas, contas: [cofre, doacoes])

      contas.each do |contas|
        [cofre, doacoes].should include contas
      end
    end

    describe "#+(contas)" do
      before :each do
        @contas_empty = build :contas, contas: []
        @cofre = build(:conta, nome: :cofre)
      end

      after :each do
      end

      context 'contas como instancia de Array' do
        it 'nova coleção de contas com as contas das duas coleções' do
          contas = @contas_empty + [@cofre]

          contas.should == build(:contas, contas: [@cofre])
          @contas_empty.should be_empty
        end
      end

      context 'contas como instancia de Contas' do
        it 'nova coleção de contas com as contas das duas coleções' do
          contas = @contas_empty + Contas.new([@cofre])

          contas.should == build(:contas, contas: [@cofre])
          @contas_empty.should be_empty
        end
      end
    end
  end
end
