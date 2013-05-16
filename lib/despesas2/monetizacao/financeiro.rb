module Monetizacao
  class Financeiro
    attr_accessor :contas
    attr_accessor :creditos_mensais
    attr_accessor :debitos_mensais
    attr_accessor :emprestimos

    NOME_CONTA_PRINCIPAL = :resto

    def initialize(contas=Contas.new, creditos_mensais={}, debitos_mensais={}, emprestimos=Hash.new(0))
      @contas = contas
      @contas << Conta.new(NOME_CONTA_PRINCIPAL)
      @creditos_mensais = creditos_mensais
      @debitos_mensais = debitos_mensais
      @emprestimos = emprestimos
    end

    def saldo_sem_resto
      contas = @contas.select{|conta| conta.nome != NOME_CONTA_PRINCIPAL}
      return contas.map(&:valor).inject(&:+)
    end

    def each_emprestimo(&block)
      emps = @emprestimos.to_a.sort_by(&:last).reverse
      emps.each{|(nome, valor)| block.call(nome, valor)}
    end

    def debitos_mensais_como_nao_pagos
      @debitos_mensais.each do |_, debito|
        debito.pago = false
      end

      @contas.each(&:debitos_mensais_como_nao_pagos)
    end

    def principal
      @contas[NOME_CONTA_PRINCIPAL]
    end

    def clone
      contas = @contas.clone

      debitos = {}
      @debitos_mensais.each do |desc, debito|
        debitos[desc] = debito.clone
      end

      creditos = @creditos_mensais.clone
      emprestimos = @emprestimos.clone
      return Financeiro.new(contas, creditos, debitos, emprestimos)
    end
  end
end
