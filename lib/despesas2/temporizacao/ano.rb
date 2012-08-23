# encoding: utf-8
module Temporizacao
  class Ano
    attr_accessor :meses, :financeiro

    MESES = %w{janeiro fevereiro março abril maio junho julho agosto setembro outubro novembro dezembro}.map(&:to_sym)
    
    def initialize(financeiro)
      @financeiro = financeiro
      @meses = {}
    end
  end
end
