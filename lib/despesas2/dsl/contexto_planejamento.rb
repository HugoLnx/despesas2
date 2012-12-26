module DSL
  class ContextoPlanejamento
    def initialize(tempo)
      @tempo = tempo
      meses = Temporizacao::Mes::NOMES
      ultimo_ano = @tempo.anos.last
      ultimo_mes = ultimo_ano.meses.last
      @ignorar_ano = lambda do |ano|
        eh_ano_anterior = ano < ultimo_ano
        eh_ultimo_mes_do_ano = ano == ultimo_ano && ultimo_mes.nome == :dezembro
        return eh_ano_anterior || eh_ultimo_mes_do_ano
      end

      @ignorar_mes = lambda do |mes, ano|
        eh_ano_atual = ultimo_ano == ano
        eh_ano_anterior = ano < ultimo_ano
        eh_mes_anterior = mes <= ultimo_mes
        return eh_ano_atual && eh_mes_anterior || eh_ano_anterior
      end
    end

    def eval(&block)
      self.instance_eval &block
    end

    def ano(num, &block)
      ano = Temporizacao::Ano.new(@tempo.financeiro.clone, num)
      return if @ignorar_ano.call(ano)
      @tempo.anos << ano

      contexto = ContextoAno.new(ano, @ignorar_mes)
      contexto.eval &block

      @tempo.financeiro = ano.financeiro
    end
  end

end
