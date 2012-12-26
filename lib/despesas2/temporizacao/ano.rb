# encoding: utf-8
module Temporizacao
  class Ano
    include Comparable
    attr_accessor :meses, :financeiro, :numero

    def initialize(financeiro, numero, meses=Meses.new)
      @financeiro = financeiro
      @numero = numero
      @meses = meses
    end

    def <=>(ano)
      @numero <=> ano.numero
    end

    def clone
      financeiro = @financeiro.clone
      meses = @meses.clone
      Ano.new(financeiro, @numero, meses)
    end
  end
end
