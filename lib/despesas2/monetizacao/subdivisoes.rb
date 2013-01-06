module Monetizacao
  class Subdivisoes
    extend Forwardable
    include Enumerable

    def initialize(subdivisoes=[])
      @subdivisoes = subdivisoes
    end

    def_delegators :@subdivisoes, :push, :<<, :empty?, :each

    def clone
      subdivisoes = @subdivisoes.map(&:clone)
      Subdivisoes.new(subdivisoes)
    end

    def [](nome)
      @subdivisoes.find{|subdivisao| subdivisao.nome == nome}
    end

    def delete(nome)
      @subdivisoes.delete_if{|subdivisao| subdivisao.nome == nome}
    end
  end
end
