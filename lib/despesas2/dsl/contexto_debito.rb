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
      nomes = financeiro.contas.map(&:nome)
      nomes << :total

      return Contexto.new do
        nomes.each do |nome|
          define_method nome do |hash|
            desc = hash.keys.first
            valor = hash.values.first
            mes.debitos[desc] = [nome, Monetizacao::Debito.pago(valor)]
          end
        end

        define_method :emprestado do |options|
          para = options[:para]
          descricao = options[:descricao]
          quantidade = options[:quantidade]
          jah_esta_incluido_no_total = options[:jah_esta_incluido_no_total]

          financeiro.emprestimos[para] += quantidade
          unless jah_esta_incluido_no_total
            financeiro.principal.valor -= quantidade
          end
        end

        define_method :mensal do |nome_ou_hash, hash=nil|
          if hash.nil?
            hash = nome_ou_hash
            nome = hash.keys.first
            valor = hash.values.first
            financeiro.debitos_mensais[nome] = Monetizacao::Debito.new(valor)
          else
            nome = nome_ou_hash
            conta = hash.keys.first
            valor = hash.values.first
            financeiro.contas[conta].debitos_mensais[nome] = Monetizacao::Debito.new(valor)
          end
        end

        define_method :mensal_pago do |nome|
          debito = financeiro.debitos_mensais[nome]

          conta = financeiro.contas.find{|sub| sub.debitos_mensais[nome]}
          debito ||= conta && conta.debitos_mensais[nome]

          debito && debito.pago = true
        end

      end
    end
  end
end
