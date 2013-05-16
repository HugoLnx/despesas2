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
  end
end
