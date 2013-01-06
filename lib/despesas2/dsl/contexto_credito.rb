module DSL
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
      nomes = financeiro.subdivisoes.map(&:nome)
      nomes << :total

      return Contexto.new do
        nomes.each do |nome|
          define_method nome do |hash|
            desc = hash.keys.first
            valor = hash.values.first
            mes.creditos[desc] = [nome, valor]
          end
        end

        define_method :devolveu do |hash_ou_quem|
          if hash_ou_quem.is_a? Hash
            quem = hash_ou_quem.keys.first
            quantidade = hash_ou_quem.values.first
          else
            quem = hash_ou_quem
            quantidade = financeiro.emprestimos[quem]
          end

          financeiro.emprestimos[quem] -= quantidade
          financeiro.principal.valor += quantidade
        end

        define_method :mensal do |hash|
          nome = hash.keys.first
          valor = hash.values.first
          financeiro.creditos_mensais[nome] = valor
        end
      end
    end
  end
end
