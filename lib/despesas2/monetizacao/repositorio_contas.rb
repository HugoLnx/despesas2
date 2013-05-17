module Monetizacao
  class RepositorioContas
    extend Forwardable
    include Enumerable

    NOME_PRINCIPAL = :principal

    attr_reader :principal
    attr_reader :secundarias

    def_delegators :todas, :empty?, :each, :[]
    def_delegators :@secundarias, :push, :<<, :delete

    def initialize(secundarias=Contas.new, principal=nil)
      @secundarias = secundarias
      @principal = principal || Conta.new(NOME_PRINCIPAL)
    end

    def todas
      @secundarias + [@principal]
    end

    def clone
      RepositorioContas.new(@secundarias.clone, @principal.clone)
    end
  end
end
