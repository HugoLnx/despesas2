module Monetizacao
  module Debito
    def self.calcular(valor, total)
      if valor.is_a? String
        porcentagem = valor.gsub(/\%/, "").to_f
        return (total * porcentagem) / 100.0
      end

      return valor
    end
  end
end
