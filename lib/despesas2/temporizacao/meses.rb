module Temporizacao
  class Meses
    extend Forwardable
    include Enumerable

    def initialize(meses=[])
      @meses = meses.sort
    end

    def_delegators :@meses, :delete_at, :empty?, :each, :last, :at

    def push(mes)
      @meses.push(mes)
      @meses.sort!
    end
    alias :<< :push

    def clone
      meses = @meses.map(&:clone)
      Meses.new(meses)
    end

    def [](numero_ou_nome)
      if numero_ou_nome.is_a? Fixnum
        numero = numero_ou_nome
        @meses.find{|mes| mes.numero == numero}
      else
        nome = numero_ou_nome
        @meses.find{|mes| mes.nome == nome}
      end
    end
  end
end
