module Temporizacao
  class Tempo
    attr_accessor :anos, :financeiro

    def initialize(financeiro)
      @financeiro = financeiro
      @anos = {}
    end
  end
end
