module DSL
  class ContextoTempo
    def initialize(tempo)
      @tempo = tempo
    end

    def eval(historia)
      self.instance_eval historia
    end

    def bigbang(&block)
      contexto = DSL::ContextoBigbang.new(@tempo)
      contexto.eval &block
    end
  end
end
