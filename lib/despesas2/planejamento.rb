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
    contexto = DSL::ContextoTempo.new(tempo)
    if File.exist? PLANEJAMENTO_PATH
      planejamento = File.read PLANEJAMENTO_PATH
    else
      Logger.new(STDOUT).warn(WARN_MSG)
      planejamento = File.read EXEMPLO_PATH
    end
    contexto.eval planejamento

    tempo.anos.first.meses.delete_at(0)
    tempo.anos.delete_at(0) if tempo.anos.first.meses.empty?

    tempo
  end

private
  def tempo_com_o_ultimo_mes(tempo)
    ultimo_ano = tempo.anos.max
    tempo.anos = Temporizacao::Anos.new([ultimo_ano])

    ultimo_mes = ultimo_ano.meses.max
    ultimo_ano.meses = Temporizacao::Meses.new([ultimo_mes])

    tempo
  end
end
