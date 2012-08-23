module DSL
  class ContextoTempo
    def initialize(tempo)
      @tempo = tempo
    end

    def eval(codigo)
      self.instance_eval codigo
    end

    def bigbang(&block)
      contexto = DSL::ContextoBigbang.new(@tempo)
      contexto.eval &block
    end

    def planejamento(&block)
      contexto = DSL::ContextoPlanejamento.new(@tempo)
      contexto.eval &block
    end
  end
end
