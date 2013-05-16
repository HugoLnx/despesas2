module DSL
  class ContextoOrganizacao
    attr_reader :financeiro

    def initialize(financeiro)
      @financeiro = financeiro
    end

    def eval(&block)
      self.instance_eval &block
    end

    def nova_conta(nome)
      conta = Monetizacao::Conta.new(nome)
      @financeiro.contas << conta
    end

    def apagar_conta(nome)
      conta = @financeiro.contas.delete(nome)
      @financeiro.principal.valor += conta.valor
    end

    def padrao(hash)
      nome = hash.keys.first
      valor = hash.values.first

      @financeiro.contas[nome].padrao = valor
    end

    def novas_contas(*nomes)
      nomes.each do |nome|
        nova_conta nome
      end
    end

    def padroes(hash)
      hash.each_pair do |chave, valor|
        padrao(chave => valor)
      end
    end

    def conta_principal(nome)
      @financeiro.conta_principal = nome
    end
  end
end
