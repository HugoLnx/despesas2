module DSL
  class ContextoPlanejamento
    def initialize(tempo)
      @tempo = tempo
      @ignorar_ano = lambda{|ano| return ano < @tempo.anos.keys.last}
      meses = Temporizacao::Ano::MESES
      ultimo_mes = @tempo.anos.values.last.meses.keys.last
      @ignorar_mes = lambda{|mes| return (meses.index(mes) <= meses.index(ultimo_mes))}
    end

    def eval(&block)
      self.instance_eval &block
    end

    def ano(num, &block)
      return if @ignorar_ano.call(num)
      ano = Temporizacao::Ano.new @tempo.financeiro.clone
      @tempo.anos[num] = ano

      contexto = ContextoAno.new(ano, @ignorar_mes)
      contexto.eval &block

      @tempo.financeiro = ano.financeiro
    end
  end

end
