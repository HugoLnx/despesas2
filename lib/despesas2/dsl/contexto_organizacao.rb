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
      subdivisao = Monetizacao::Subdivisao.new(nome)
      @financeiro.subdivisoes << subdivisao
    end

    def apagar_conta(nome)
      subdivisao = @financeiro.subdivisoes.delete(nome)
      @financeiro.principal.valor += subdivisao.valor
    end

    def padrao(hash)
      nome = hash.keys.first
      valor = hash.values.first

      @financeiro.subdivisoes[nome].padrao = valor
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
      @financeiro.subdivisao_principal = nome
    end
  end
end
