module Temporizacao
  class Anos
    extend Forwardable
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

    def_delegators :@anos, :at, :delete_at, :empty?, :each, :last
  end
end
