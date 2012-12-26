# encoding: utf-8
require 'spec_helper'

module Temporizacao
  describe Meses do
    it 'inserção e recuperação' do
      janeiro = build(:mes, numero: 1)
      fevereiro = build(:mes, numero: 2)
      abril = build(:mes, numero: 4)

      meses = build(:meses)

      meses << janeiro
      meses << abril
      meses << fevereiro

      meses[1].should == janeiro
      meses[:janeiro].should == janeiro

      meses[4].should == abril
      meses[:abril].should == abril
    end

    it 'coleção' do
      meses = build(:meses)

      janeiro = build(:mes, numero: 1)
      fevereiro = build(:mes, numero: 2)
      abril = build(:mes, numero: 4)

      meses << abril
      meses << fevereiro
      meses << janeiro

      ordem_certa = [janeiro, fevereiro, abril]

      meses.each.with_index do |mes, i|
        mes.should == ordem_certa[i]
      end

      meses.first.should == janeiro
      meses.last.should == abril
    end
  end
end
