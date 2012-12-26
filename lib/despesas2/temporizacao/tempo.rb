module Temporizacao
  class Tempo
    attr_accessor :anos, :financeiro

    def initialize(financeiro, anos=Anos.new)
      @financeiro = financeiro
      @anos = anos
    end

    def clone
      financeiro = @financeiro.clone
      anos = @anos.clone
      Tempo.new(financeiro, anos)
    end
  end
end
