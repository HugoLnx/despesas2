module DSL
  class Bigbang
    attr_reader :tempo

    def initialize(tempo)
      @tempo = tempo
    end

    def eval(historia)
      self.instance_eval historia
    end

    def bigbang(&block)
      contexto = DSL::ContextoTempo.new(@tempo)
      contexto.eval &block
    end
  end
end
