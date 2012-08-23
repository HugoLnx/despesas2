module Temporizacao
  class Mes
    attr_accessor :financeiro
    attr_accessor :creditos
    attr_accessor :debitos

    def initialize(financeiro)
      @financeiro = financeiro
      @creditos = {}
      @debitos = {}
    end

    def clone
      clone = super
      clone.financeiro = @financeiro.clone
      creditos = {}
      @creditos.each_pair do |nome, credito|
        creditos[nome] = credito.clone
      end
      clone.creditos = creditos

      debitos = {}
      @debitos.each_pair do |nome, debito|
        debitos[nome] = debito.clone
      end
      clone.debitos = debitos

      return clone
    end

    def aplicar_creditos_e_debitos
      credito = soma_creditos(:total)
      debito = soma_debitos(:total, credito)

      saldo = credito
      saldo -= debito

      @financeiro.subdivisoes.each do |nome, subdivisao|
        padrao = Monetizacao::Debito.calcular(subdivisao.padrao, credito)
        saldo -= padrao

        subdivisao.valor += padrao
        subdivisao.valor += soma_creditos(nome)
        subdivisao.valor -= soma_debitos(nome, credito, subdivisao)
      end

      principal = @financeiro.subdivisao_principal
      @financeiro.subdivisoes[principal].valor += saldo
    end
  private

    def soma_creditos(nome)
      total = @creditos.values.select{|(name,valor)| name == nome}.map(&:last).inject(0.0, &:+)
      if nome == :total
        total += @financeiro.creditos_mensais.values.inject(0.0, &:+)
      end
      return total
    end

    def soma_debitos(nome, credito, subdivisao=nil)
      debitos = @debitos.values
      if nome == :total && subdivisao.nil?
        mensais = @financeiro.debitos_mensais
      else
        mensais = subdivisao.debitos_mensais
      end
      debitos += mensais.values.map{|valor| [nome, valor]}
      debitos = debitos.map{|(sub,valor)| [sub, Monetizacao::Debito.calcular(valor, credito)]}
      debitos = debitos.select{|(sub,val)| sub == nome}
      return debitos.map(&:last).inject(0.0, &:+)
    end
  end
end
