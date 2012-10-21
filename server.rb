require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
require './lib/despesas2'

require 'json'
require 'sinatra'
require 'sinatra/partial'

set :partial_template_engine, :erb
enable :partial_underscores

get "/" do
  @tempo = Historia.carregar_tempo
  @tempop = Planejamento.new(@tempo).carregar_tempo

  erb :index
end

get "/emprestimos" do
  @tempo = Historia.carregar_tempo
  @tempop = Planejamento.new(@tempo).carregar_tempo

  erb :emprestimos
end

helpers do
  def dinheiro(valor)
    return sprintf("%.2f", valor)
  end

  def class_lucro(valor)
    if valor > 0
      return "lucro"
    elsif valor < 0
      return "prejuizo"
    else
      return "estavel"
    end
  end
end
