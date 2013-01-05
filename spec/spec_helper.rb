SPEC_ROOT = File.dirname(File.expand_path(__FILE__))

require 'rubygems'
require 'bundler/setup'
Bundler.setup(:default)
Bundler.setup(:test)
require './lib/despesas2.rb'

require 'factory_girl'

Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each {|f| require f}


RSpec.configure do |config|
  FactoryGirl.find_definitions
  config.include FactoryGirl::Syntax::Methods
end
