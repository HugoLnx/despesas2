# encoding: utf-8

# DEVE GUARDAR SOMENTE VALORES E NOME DAS SUBDIVISOES
module Monetizacao
  class Financeiro
    attr_accessor :subdivisoes
    attr_accessor :subdivisao_principal
    attr_accessor :creditos_mensais
    attr_accessor :debitos_mensais

    def initialize
      @subdivisoes = {}
      @subdivisao_principal = nil
      @creditos_mensais = {} # tirar isso (nao deve guardar descricoes ou nomes) 
      @debitos_mensais = {}  # tirar isso (nao deve guardar descricoes ou nomes) 
    end
  end

  class Subdivisao
    attr_accessor :padrao, :valor, :debitos_mensais

    def initialize
      @padrao = 0.0
      @valor = 0.0
      @debitos_mensais = {} #tirar isso (nao deve guardar descricoes ou nomes)
    end

    def depositar(valor)
      @valor += valor
    end

    def debitar(valor)
      @valor -= valor
    end
  end
end

# DEVE GUARDAR DESCRICOES E VALORES A SEREM INSERIDOS
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

  class Mes
    attr_accessor :financeiro

    def initialize(financeiro)
      @financeiro = financeiro
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
      contexto = ContextoCredito.new(@mes.financeiro.clone)
      contexto.eval &block

      @mes.financeiro = contexto.financeiro
    end

    def debito(&block)
      contexto = ContextoDebito.new(@mes.financeiro.clone)
      contexto.eval &block

      @mes.financeiro = contexto.financeiro
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
    attr_reader :financeiro

    def initialize(financeiro)
      @financeiro = financeiro

      @contexto = contexto
    end

    def eval(&block)
      @contexto.instance_eval &block
    end

  private

    def contexto
      financeiro = @financeiro

      return Contexto.new do
        financeiro.subdivisoes.each_key do |nome|
          define_method nome do |valor|
            financeiro.subdivisoes[nome].depositar valor
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
    attr_reader :financeiro

    def initialize(financeiro)
      @financeiro = financeiro

      @contexto = contexto
    end

    def eval(&block)
      @contexto.instance_eval &block
    end

  private

    def contexto
      financeiro = @financeiro

      return Contexto.new do
        financeiro.subdivisoes.each_key do |nome|
          define_method nome do |valor|
            financeiro.subdivisoes[nome].debitar valor
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
        resto 1000.0
        cofre 2000.0
      end
    end
  
    agosto do
      organizacao do
        novas_subdivisoes(
          :saude, :presentes,
          :roupas, :lazer
        )
  
        padroes(
          cofre: "%15",
          doacoes: "%15",
          saude: 100.0,
          presentes: 100.0,
          roupas: 100.0,
          lazer: 200.0
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
        #total 100.0 #total "extra" => 100.0
      end

      debito do
        #doacoes 10.0 #doacoes "caridade" => 10.0
      end
    end
  end
end
