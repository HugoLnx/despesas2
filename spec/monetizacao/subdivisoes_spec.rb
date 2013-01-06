# encoding: utf-8
require 'spec_helper'

module Monetizacao
  describe Subdivisoes do
    it 'inserção e recuperação' do
      cofre = build(:subdivisao, nome: :cofre)
      doacoes = build(:subdivisao, nome: :doacoes)

      subdivisoes = build(:subdivisoes)

      subdivisoes << cofre
      subdivisoes << doacoes

      subdivisoes[:cofre].should == cofre
      subdivisoes[:doacoes].should == doacoes
    end

    it 'coleção' do
      cofre = build(:subdivisao, nome: :cofre)
      doacoes = build(:subdivisao, nome: :doacoes)

      subdivisoes = build(:subdivisoes, subdivisoes: [cofre, doacoes])

      subdivisoes.each do |subdivisao|
        [cofre, doacoes].should include subdivisao
      end
    end
  end
end
