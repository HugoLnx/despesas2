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
end
