module Temporizacao
  class Tempo
    attr_accessor :anos, :financeiro

    def initialize(financeiro)
      @financeiro = financeiro
      @anos = {}
    end

    def clone
      clone = super
      clone.financeiro = financeiro.clone
      clone_anos = {}
      @anos.each_pair do |nome, ano|
        clone_anos[nome] = ano.clone
      end
      clone.anos = clone_anos
      return clone
    end
  end
end
