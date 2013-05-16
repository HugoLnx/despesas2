module Monetizacao
  class Contas
    extend Forwardable
    include Enumerable

    def initialize(contas=[])
      @contas = contas
    end

    def_delegators :@contas, :push, :<<, :empty?, :each

    def clone
      contas = @contas.map(&:clone)
      Contas.new(contas)
    end

    def [](nome)
      @contas.find{|conta| conta.nome == nome}
    end

    def delete(nome)
      i = @contas.index{|conta| conta.nome == nome}
      @contas.delete_at i
    end
  end
end
