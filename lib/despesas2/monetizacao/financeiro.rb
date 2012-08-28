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
      clone.creditos_mensais = @creditos_mensais.clone
      clone.debitos_mensais = @debitos_mensais.clone
      clone.emprestimos = @emprestimos.clone
      return clone
    end
  end
end
