module Monetizacao
  class Financeiro
    attr_accessor :subdivisoes
    attr_accessor :subdivisao_principal
    attr_accessor :creditos_mensais
    attr_accessor :debitos_mensais
    attr_accessor :emprestimos

    alias :contas :subdivisoes
    alias :conta_principal :subdivisao_principal

    def initialize(subdivisoes=Subdivisoes.new, subdivisao_principal=nil, creditos_mensais={}, debitos_mensais={}, emprestimos=Hash.new(0))
      @subdivisoes = subdivisoes
      @subdivisao_principal = subdivisao_principal
      @creditos_mensais = creditos_mensais
      @debitos_mensais = debitos_mensais
      @emprestimos = emprestimos
    end

    def saldo_sem_resto
      subs = @subdivisoes.select{|sub| sub.nome != @subdivisao_principal}
      return subs.map(&:valor).inject(&:+)
    end

    def each_emprestimo(&block)
      emps = @emprestimos.to_a.sort_by(&:last).reverse
      emps.each{|(nome, valor)| block.call(nome, valor)}
    end

    def debitos_mensais_como_nao_pagos
      @debitos_mensais.each do |_, debito|
        debito.pago = false
      end

      @subdivisoes.each(&:debitos_mensais_como_nao_pagos)
    end

    def principal
      @subdivisoes[@subdivisao_principal]
    end

    def clone
      subdivisoes = @subdivisoes.clone

      debitos = {}
      @debitos_mensais.each do |desc, debito|
        debitos[desc] = debito.clone
      end

      creditos = @creditos_mensais.clone
      emprestimos = @emprestimos.clone
      return Financeiro.new(subdivisoes, @subdivisao_principal, creditos, debitos, emprestimos)
    end
  end
end
