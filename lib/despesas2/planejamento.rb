# encoding: utf-8
class Planejamento
  PLANEJAMENTO_PATH = "./dados/planejamento.rb"
  EXEMPLO_PATH ="./dados/planejamento.exemplo.rb"
  WARN_MSG = "Você está usando o arquivo de exemplo para o planejamento, para usar seu próprio crie #{PLANEJAMENTO_PATH}" 

  def initialize(tempo)
    @tempo = tempo
  end

  def carregar_tempo
    tempo = @tempo.clone
    tempo = tempo_com_o_ultimo_mes(tempo)
    bigbang = DSL::ContextoTempo.new(tempo)
    if File.exist? PLANEJAMENTO_PATH
      historia = File.read PLANEJAMENTO_PATH
    else
      Logger.new(STDOUT).warn(WARN_MSG)
      historia = File.read EXEMPLO_PATH
    end
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
