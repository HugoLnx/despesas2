# encoding: utf-8
module Temporizacao
  class Ano
    attr_accessor :meses, :financeiro

    MESES = %w{janeiro fevereiro março abril maio junho julho agosto setembro outubro novembro dezembro}.map(&:to_sym)
    
    def initialize(financeiro)
      @financeiro = financeiro
      @meses = {}
    end

    def clone
      clone = super
      clone.financeiro = @financeiro.clone
      clone_meses = {}
      @meses.each_pair do |nome, mes|
        clone_meses[nome] = mes.clone
      end
      clone.meses = clone_meses
      return clone
    end
  end
end
