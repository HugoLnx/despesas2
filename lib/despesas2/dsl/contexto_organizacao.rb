module DSL
  class ContextoOrganizacao
    attr_reader :financeiro

    def initialize(financeiro)
      @financeiro = financeiro
    end

    def eval(&block)
      self.instance_eval &block
    end

    def nova_subdivisao(nome)
      subdivisao = Monetizacao::Subdivisao.new
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
end
