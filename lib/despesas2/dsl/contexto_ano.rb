module DSL
  class ContextoAno
    def initialize(ano, ignorar_mes=lambda{|nome| return false})
      @ano = ano
      @ignorar_mes = ignorar_mes
    end

    def eval(&block)
      self.instance_eval &block
    end
    
    Temporizacao::Ano::MESES.each do |nome|
      define_method nome do |fechou=nil, &block|
        return if @ignorar_mes.call(nome)
        mes = Temporizacao::Mes.new @ano.financeiro.clone
        mes.fechamento = fechou[:fechou] unless fechou.nil?
        @ano.meses[nome] = mes

        contexto = ContextoMes.new(mes)
        contexto.eval &block

        mes.aplicar_creditos_e_debitos
        @ano.financeiro = mes.financeiro
      end
    end
  end
end
