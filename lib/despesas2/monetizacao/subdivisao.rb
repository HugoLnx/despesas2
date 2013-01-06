module Monetizacao
  class Subdivisao
    attr_accessor :padrao, :valor, :debitos_mensais
    attr_reader :nome

    def initialize(nome, padrao=0.0, valor=0.0, debitos_mensais={})
      @nome = nome
      @padrao = padrao
      @valor = valor
      @debitos_mensais = debitos_mensais
    end

    def debitos_mensais_como_nao_pagos
      @debitos_mensais.each do |_, debito|
        debito.pago = false
      end
    end

    def clone
      clone = super

      clone_debitos = {}
      @debitos_mensais.each do |desc, debito|
        clone_debitos[desc] = debito.clone
      end
      clone.debitos_mensais = clone_debitos

      return clone
    end

    def depositar(valor)
      @valor += valor
    end

    def debitar(valor)
      @valor -= valor
    end
  end
end
