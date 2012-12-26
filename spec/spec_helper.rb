require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
Bundler.setup(:test)
require './lib/despesas2.rb'

require 'factory_girl'


RSpec.configure do |config|
  FactoryGirl.find_definitions
  config.include FactoryGirl::Syntax::Methods
end
