class Planejamento
  def initialize(tempo)
    @tempo = tempo
  end

  def carregar_tempo
    tempo = @tempo.clone
    tempo = tempo_com_o_ultimo_mes(tempo)
    bigbang = DSL::ContextoTempo.new(tempo)
    historia = File.read "./dados/planejamento.rb"
    bigbang.eval historia
    return tempo
  end

private
  def tempo_com_o_ultimo_mes(tempo)
    ano = tempo.anos.keys.max
    ultimo_ano = tempo.anos[ano]
    tempo.anos = {ano => ultimo_ano}

    mes = ultimo_ano.meses.keys.max_by{|mes| Temporizacao::Ano::MESES.index(mes)}
    ultimo_mes = ultimo_ano.meses[mes]
    ultimo_ano.meses = {mes => ultimo_mes}

    return tempo
  end
end
