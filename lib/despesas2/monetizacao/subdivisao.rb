module Monetizacao
  class Subdivisao
    attr_accessor :padrao, :valor, :debitos_mensais

    def initialize
      @padrao = 0.0
      @valor = 0.0
      @debitos_mensais = {}
    end

    def clone
      clone = super
      clone.debitos_mensais = @debitos_mensais.clone
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
