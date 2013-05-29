module Monetizacao
  class Contas
    extend Model::ColecaoNomeada

    def initialize(contas=[])
      @contas = contas
    end

    colecao_nomeada_para :@contas
  end
end
