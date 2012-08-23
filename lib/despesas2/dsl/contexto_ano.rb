module DSL
  class ContextoAno
    def initialize(ano)
      @ano = ano
    end

    def eval(&block)
      self.instance_eval &block
    end
    
    Temporizacao::Ano::MESES.each do |nome|
      define_method nome do |&block|
        mes = Temporizacao::Mes.new @ano.financeiro.clone
        @ano.meses[nome] = mes

        contexto = ContextoMes.new(mes)
        contexto.eval &block

        mes.aplicar_creditos_e_debitos
        @ano.financeiro = mes.financeiro
      end
    end
  end
end
