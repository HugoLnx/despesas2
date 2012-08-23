module Historia
  def self.carregar_tempo
    tempo = Temporizacao::Tempo.new(Monetizacao::Financeiro.new)
    bigbang = DSL::Bigbang.new(tempo)
    historia = File.read "./dados/historia.rb"
    bigbang.eval historia
    return tempo
  end
end
