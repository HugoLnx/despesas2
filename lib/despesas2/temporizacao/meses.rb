module Temporizacao
  class Meses
    include Enumerable

    def initialize(meses=[])
      @meses = meses.sort
    end

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

    def at(i)
      @meses[i]
    end

    def delete_at(i)
      @meses.delete_at(i)
    end

    def empty?
      @meses.empty?
    end

    def each(&block)
      @meses.each(&block)
    end

    def last(*args)
      @meses.last(*args)
    end
  end
end
