module DSL
  class ContextoMes
    def initialize(mes)
      @mes = mes
    end

    def eval(&block)
      self.instance_eval &block
    end

    def organizacao(&block)
      contexto = ContextoOrganizacao.new(@mes.financeiro.clone)
      contexto.eval &block

      @mes.financeiro = contexto.financeiro
    end

    def credito(&block)
      contexto = ContextoCredito.new(@mes)
      contexto.eval &block
    end

    def debito(&block)
      contexto = ContextoDebito.new(@mes)
      contexto.eval &block
    end
  end
end
