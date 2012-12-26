module DSL
  class ContextoBigbang
    def initialize(tempo)
      @tempo = tempo
    end

    def eval(&block)
      self.instance_eval &block
    end

    def ano(num, &block)
      ano = Temporizacao::Ano.new @tempo.financeiro.clone, num
      @tempo.anos << ano

      contexto = ContextoAno.new(ano)
      contexto.eval &block

      @tempo.financeiro = ano.financeiro
    end
  end
end
