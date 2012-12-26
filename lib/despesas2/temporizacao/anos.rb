module Temporizacao
  class Anos
    include Enumerable

    def initialize(anos=[])
      @anos = anos.sort
    end

    def push(ano)
      @anos.push(ano)
      @anos.sort!
    end
    alias :<< :push

    def clone
      anos = @anos.map(&:clone)
      Anos.new(anos)
    end

    def [](numero)
      @anos.find{|ano| ano.numero == numero}
    end

    def at(i)
      @anos[i]
    end

    def delete_at(i)
      @anos.delete_at(i)
    end

    def empty?
      @anos.empty?
    end

    def each(&block)
      @anos.each(&block)
    end

    def last(*args)
      @anos.last(*args)
    end
  end
end
