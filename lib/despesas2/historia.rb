# encoding: utf-8
module Historia
  HISTORIA_PATH = "./dados/historia.rb"
  EXEMPLO_PATH = "./dados/historia.exemplo.rb"
  WARN_MSG = "Você está usando o arquivo de exemplo para a história, para usar seu próprio crie #{HISTORIA_PATH}" 

  def self.carregar_tempo
    tempo = Temporizacao::Tempo.new(Monetizacao::Financeiro.new)
    bigbang = DSL::ContextoTempo.new(tempo)
    if File.exist? HISTORIA_PATH
      historia = File.read HISTORIA_PATH
    else
      Logger.new(STDOUT).warn(WARN_MSG)
      historia = File.read EXEMPLO_PATH
    end
    bigbang.eval historia

    return tempo
  end
end
