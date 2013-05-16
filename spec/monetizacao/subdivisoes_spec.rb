# encoding: utf-8
require 'spec_helper'

module Monetizacao
  describe Contas do
    it 'inserção e recuperação' do
      cofre = build(:conta, nome: :cofre)
      doacoes = build(:conta, nome: :doacoes)

      subdivisoes = build(:contas)

      subdivisoes << cofre
      subdivisoes << doacoes

      subdivisoes[:cofre].should == cofre
      subdivisoes[:doacoes].should == doacoes
    end

    it 'coleção' do
      cofre = build(:conta, nome: :cofre)
      doacoes = build(:conta, nome: :doacoes)

      subdivisoes = build(:contas, subdivisoes: [cofre, doacoes])

      subdivisoes.each do |subdivisao|
        [cofre, doacoes].should include subdivisao
      end
    end
  end
end
