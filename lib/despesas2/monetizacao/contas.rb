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

    def +(contas)
      contas = contas.to_a
      Contas.new(@contas + contas)
    end

    def ==(contas)
      contas.is_a?(Contas) &&
      self.to_a.sort == contas.to_a.sort
    end

    def delete(nome)
      i = @contas.index{|conta| conta.nome == nome}
      @contas.delete_at i
    end
  end
end
