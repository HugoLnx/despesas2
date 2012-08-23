module Monetizacao
  class Financeiro
    attr_accessor :subdivisoes
    attr_accessor :subdivisao_principal
    attr_accessor :creditos_mensais
    attr_accessor :debitos_mensais

    def initialize
      @subdivisoes = {}
      @subdivisao_principal = nil
      @creditos_mensais = {}
      @debitos_mensais = {}
    end

    def clone
      clone = super
      clone_subdivisoes = {}
      @subdivisoes.each do |nome, subdivisao|
        clone_subdivisoes[nome] = subdivisao.clone
      end
      clone.subdivisoes = clone_subdivisoes
      clone.creditos_mensais = @creditos_mensais.clone
      clone.debitos_mensais = @debitos_mensais.clone
      return clone
    end
  end
end
