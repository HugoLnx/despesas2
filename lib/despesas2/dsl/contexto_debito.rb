module DSL
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
end
