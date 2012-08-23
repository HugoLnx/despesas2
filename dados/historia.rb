# encoding: utf-8

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

module Temporizacao
  class Tempo
    attr_accessor :anos, :financeiro

    def initialize(financeiro)
      @financeiro = financeiro
      @anos = {}
    end
  end

  class Ano
    attr_accessor :meses, :financeiro

    MESES = %w{janeiro fevereiro março abril maio junho julho agosto setembro outubro novembro dezembro}.map(&:to_sym)
    
    def initialize(financeiro)
      @financeiro = financeiro
      @meses = {}
    end
  end

  module Debito
    def self.calcular(valor, total)
      if valor.is_a? String
        porcentagem = valor.gsub(/\%/, "").to_f
        return (total * porcentagem) / 100.0
      end

      return valor
    end
  end

  class Mes
    attr_accessor :financeiro
    attr_accessor :creditos
    attr_accessor :debitos

    def initialize(financeiro)
      @financeiro = financeiro
      @creditos = {}
      @debitos = {}
    end

    def aplicar_creditos_e_debitos
      credito = soma_creditos(:total)
      debito = soma_debitos(:total, credito)

      saldo = credito
      saldo -= debito

      @financeiro.subdivisoes.each do |nome, subdivisao|
        padrao = Debito.calcular(subdivisao.padrao, credito)
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
      debitos = debitos.map{|(sub,valor)| [sub, Debito.calcular(valor, credito)]}
      debitos = debitos.select{|(sub,val)| sub == nome}
      return debitos.map(&:last).inject(0.0, &:+)
    end
  end
end

include Monetizacao
include Temporizacao

module DSL
  class ContextoTempo
    def initialize(tempo)
      @tempo = tempo
    end

    def ano(num, &block)
      ano = Ano.new @tempo.financeiro.clone
      @tempo.anos[num] = ano

      contexto = ContextoAno.new(ano)
      contexto.eval &block

      @tempo.financeiro = ano.financeiro
    end
  end

  class ContextoAno
    def initialize(ano)
      @ano = ano
    end

    def eval(&block)
      self.instance_eval &block
    end
    
    Ano::MESES.each do |nome|
      define_method nome do |&block|
        mes = Mes.new @ano.financeiro.clone
        @ano.meses[nome] = mes

        contexto = ContextoMes.new(mes)
        contexto.eval &block

        mes.aplicar_creditos_e_debitos
        @ano.financeiro = mes.financeiro
      end
    end
  end

  class ContextoMes
    def initialize(mes)
      @mes = mes
    end

    def eval(&block)
      self.instance_eval &block
    end

    def organizacao(&block)
      contexto = ContextoOrganizacao.new(@mes.financeiro.clone)
      contexto.eval &block

      @mes.financeiro = contexto.financeiro
    end

    def credito(&block)
      contexto = ContextoCredito.new(@mes)
      contexto.eval &block
    end

    def debito(&block)
      contexto = ContextoDebito.new(@mes)
      contexto.eval &block
    end
  end

  class ContextoOrganizacao
    attr_reader :financeiro

    def initialize(financeiro)
      @financeiro = financeiro
    end

    def eval(&block)
      self.instance_eval &block
    end

    def nova_subdivisao(nome)
      subdivisao = Subdivisao.new
      @financeiro.subdivisoes[nome] = subdivisao
    end

    def padrao(hash)
      nome = hash.keys.first
      valor = hash.values.first

      @financeiro.subdivisoes[nome].padrao = valor
    end

    def novas_subdivisoes(*nomes)
      nomes.each do |nome|
        nova_subdivisao nome
      end
    end

    def padroes(hash)
      hash.each_pair do |chave, valor|
        padrao(chave => valor)
      end
    end

    def subdivisao_principal(nome)
      @financeiro.subdivisao_principal = nome
    end
  end

  class ContextoCredito
    attr_reader :mes

    def initialize(mes)
      @mes = mes

      @contexto = contexto
    end

    def eval(&block)
      @contexto.instance_eval &block
    end

  private

    def contexto
      financeiro = @mes.financeiro
      mes = @mes
      subdivisoes = financeiro.subdivisoes.keys
      subdivisoes << :total

      return Contexto.new do
        subdivisoes.each do |nome|
          define_method nome do |hash|
            desc = hash.keys.first
            valor = hash.values.first
            mes.creditos[desc] = [nome, valor]
          end
        end

        define_method :mensal do |hash|
          nome = hash.keys.first
          valor = hash.values.first
          financeiro.creditos_mensais[nome] = valor
        end
      end
    end
  end

  class ContextoDebito
    attr_reader :mes

    def initialize(mes)
      @mes = mes

      @contexto = contexto
    end

    def eval(&block)
      @contexto.instance_eval &block
    end

  private

    def contexto
      financeiro = @mes.financeiro
      mes = @mes
      subdivisoes = financeiro.subdivisoes.keys
      subdivisoes << :total

      return Contexto.new do
        subdivisoes.each do |nome|
          define_method nome do |hash|
            desc = hash.keys.first
            valor = hash.values.first
            mes.debitos[desc] = [nome, valor]
          end
        end

        define_method :mensal do |nome_ou_hash, hash=nil|
          if hash.nil?
            hash = nome_ou_hash
            nome = hash.keys.first
            valor = hash.values.first
            financeiro.debitos_mensais[nome] = valor
          else
            nome = nome_ou_hash
            subdivisao = hash.keys.first
            valor = hash.values.first
            financeiro.subdivisoes[subdivisao].debitos_mensais[nome] = valor
          end
        end
      end
    end
  end

  class Contexto < Module
    def initialize(*args, &block)
      self.instance_eval do
        extend self
      end

      super(*args, &block)
    end
  end
end

@tempo = Tempo.new(Financeiro.new)

def bigbang(&block)
  contexto = ContextoTempo.new(@tempo)
  contexto.instance_eval &block
end
include DSL

bigbang do
  ano 2012 do
    julho do
      organizacao do
        nova_subdivisao :resto
        subdivisao_principal :resto
  
        nova_subdivisao :cofre
        nova_subdivisao :doacoes
      end
  
      credito do
        resto "resto inicial" => 1000.0
        cofre "cofre inicial" => 2000.0
      end
    end
  
    agosto do
      organizacao do
        novas_subdivisoes(
          :saude, :presentes,
          :roupas, :lazer,
          :aposentadoria
        )
  
        padroes(
          cofre: "%15",
          doacoes: "%15",
          saude: 100.0,
          presentes: 100.0,
          roupas: 100.0,
          lazer: 200.0,
          aposentadoria: "10%"
        )
      end
  
      credito do
        mensal "salario estagio" => 1000.0
      end
  
      debito do
        mensal "ajuda lar" => "%10"
        mensal "daniel cristóvão", doacoes: 50.0
        mensal "anália franco", doacoes: 25.0
      end
    end

    setembro do
      credito do
        total "extra" => 100.0
      end

      debito do
        doacoes "caridade" => 10.0
      end
    end
  end
end
