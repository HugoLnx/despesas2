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
      isub = @subdivisoes.index{|subdivisao| subdivisao.nome == nome}
      @subdivisoes.delete_at isub
    end
  end
end
