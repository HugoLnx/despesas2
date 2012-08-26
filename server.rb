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

