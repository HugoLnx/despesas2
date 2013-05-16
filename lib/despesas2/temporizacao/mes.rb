# encoding: utf-8
module Temporizacao
  class Mes
    include Comparable

    NOMES = %w{janeiro fevereiro março abril maio junho julho agosto setembro outubro novembro dezembro}.map(&:to_sym)

    attr_accessor :financeiro
    attr_accessor :creditos
    attr_accessor :debitos
    attr_accessor :fechamento
    attr_reader :numero

    def initialize(financeiro, numero, creditos={}, debitos={}, fechamento=nil)
      @financeiro = financeiro
      @numero = numero
      @creditos = {}
      @debitos = {}
      @fechamento = nil
    end

    def nome
      NOMES[@numero-1]
    end

    def <=>(mes)
      @numero <=> mes.numero
    end

    def clone
      financeiro = @financeiro.clone
      creditos = {}
      @creditos.each_pair do |nome, credito|
        creditos[nome] = credito.clone
      end

      debitos = {}
      @debitos.each_pair do |nome, debito_pair|
        debitos[nome] = [debito_pair[0], debito_pair[1].clone]
      end

      Mes.new(financeiro, @numero, creditos, debitos, @fechamento)
    end

    def aplicar_creditos_e_debitos
      credito = soma_creditos(:total)
      debito = soma_debitos(:total, credito)

      saldo = credito
      saldo -= debito

      @financeiro.contas.each do |conta|
        padrao = Monetizacao::Debito.calcular(conta.padrao, credito)
        saldo -= padrao

        conta.valor += padrao
        conta.valor += soma_creditos(conta.nome)
        conta.valor -= soma_debitos(conta.nome, credito, conta)
      end

      nome = @financeiro.conta_principal
      principal = @financeiro.principal
      if @fechamento.nil?
        principal.valor += saldo
      else
        sem_resto = @financeiro.saldo_sem_resto
        principal.valor = fechamento - sem_resto
      end
    end

    def total_credito(nome)
      credito = soma_creditos :total
      return credito if nome == :total

      creditos_normais = soma_creditos nome
      padrao = Monetizacao::Debito.calcular(@financeiro.contas[nome].padrao, credito)
      return padrao + creditos_normais
    end

    def total_debito(nome)
      credito = soma_creditos :total
      if nome == :total
        conta = nil
      else
        conta = @financeiro.contas[nome]
      end
      return soma_debitos(nome, credito, conta)
    end

    def debito_total
      nomes = @financeiro.contas.map(&:nome)
      nomes.delete(@financeiro.conta_principal)
      nomes.map{|nome| total_credito(nome)}.inject(:+)
    end

    def debitos_pendentes
      debitos = @financeiro.debitos_mensais.to_a
      debitos += @financeiro.contas.inject([]){|debitos, conta| debitos + conta.debitos_mensais.to_a}

      debitos = debitos.find_all{|(_, debito)| !debito.pago?}

      credito = soma_creditos :total

      debitos.map{|(nome, debito)| [nome, Monetizacao::Debito.calcular(debito.valor, credito)]}
    end

    def diff(nome=:total)
      total_credito(nome) - total_debito(nome)
    end

  private

    def soma_creditos(nome)
      total = @creditos.values.select{|(name,valor)| name == nome}.map(&:last).inject(0.0, &:+)
      if nome == :total
        total += @financeiro.creditos_mensais.values.inject(0.0, &:+)
      end
      return total
    end

    def soma_debitos(nome, credito, conta=nil)
      debitos = @debitos.values.map{|(nome, debito)| [nome, debito.valor]}

      if nome == :total && conta.nil?
        mensais = @financeiro.debitos_mensais
      else
        mensais = conta.debitos_mensais
      end
      debitos += mensais.values.map{|debito| [nome, debito.valor]}
      debitos = debitos.map{|(conta,valor)| [conta, Monetizacao::Debito.calcular(valor, credito)]}
      debitos = debitos.select{|(conta,val)| conta == nome}
      return debitos.map(&:last).inject(0.0, &:+)
    end
  end
end
