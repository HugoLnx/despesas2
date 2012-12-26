module DSL
  class ContextoAno
    def initialize(ano, ignorar_mes=lambda{|mes, ano| return false})
      @ano = ano
      @ignorar_mes = ignorar_mes
    end

    def eval(&block)
      self.instance_eval &block
    end
    
    Temporizacao::Mes::NOMES.each.with_index do |nome, i|
      numero = i + 1
      define_method nome do |fechou=nil, &block|
        mes = Temporizacao::Mes.new(@ano.financeiro.clone, numero)
        return if @ignorar_mes.call(mes, @ano)
        mes.fechamento = fechou[:fechou] unless fechou.nil?
        @ano.meses << mes

        mes.financeiro.debitos_mensais_como_nao_pagos
        contexto = ContextoMes.new(mes)
        contexto.eval &block

        mes.aplicar_creditos_e_debitos

        @ano.financeiro = mes.financeiro
      end
    end
  end
end
