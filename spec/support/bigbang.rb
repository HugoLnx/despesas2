def bigbang(&block)
  tempo = Temporizacao::Tempo.new(Monetizacao::Financeiro.new)
  contexto = DSL::ContextoBigbang.new(tempo)
  contexto.eval(&block)

  self.subject{tempo}
end
