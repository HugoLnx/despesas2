module Monetizacao
  class Financeiro
    attr_accessor :subdivisoes
    attr_accessor :subdivisao_principal
    attr_accessor :creditos_mensais
    attr_accessor :debitos_mensais
    attr_accessor :emprestimos

    def initialize
      @subdivisoes = {}
      @subdivisao_principal = nil
      @creditos_mensais = {}
      @debitos_mensais = {}
      @emprestimos = Hash.new(0)
    end

    def saldo_sem_resto
      subs = @subdivisoes.select{|nome, sub| nome != @subdivisao_principal}.map(&:last)
      return subs.map(&:valor).inject(&:+)
    end

    def debitos_mensais_como_nao_pagos
      @debitos_mensais.each do |_, debito|
        debito.pago = false
      end

      @subdivisoes.map(&:last).each(&:debitos_mensais_como_nao_pagos)
    end

    def principal
      return @subdivisoes[@subdivisao_principal]
    end

    def clone
      clone = super

      clone_subdivisoes = {}
      @subdivisoes.each do |nome, subdivisao|
        clone_subdivisoes[nome] = subdivisao.clone
      end
      clone.subdivisoes = clone_subdivisoes

      clone_debitos = {}
      @debitos_mensais.each do |desc, debito|
        clone_debitos[desc] = debito.clone
      end
      clone.debitos_mensais = clone_debitos

      clone.creditos_mensais = @creditos_mensais.clone
      clone.emprestimos = @emprestimos.clone
      return clone
    end
  end
end
