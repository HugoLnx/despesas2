module Monetizacao
  class Debito
    attr_reader :valor
    attr_writer :pago

    def initialize(valor, pago=false)
      @valor = valor
      @pago = pago
    end

    def pago?
      @pago
    end

    def self.pago(valor)
      return Debito.new(valor, true)
    end

    def self.calcular(valor, total)
      if valor.is_a? String
        porcentagem = valor.gsub(/\%/, "").to_f
        return (total * porcentagem) / 100.0
      end

      return valor
    end
  end
end
