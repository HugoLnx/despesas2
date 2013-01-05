# encoding: utf-8
require 'spec_helper'

describe "subdivisoes" do
  bigbang do
    ano 2012 do
      janeiro fechou: 5000.0 do
        organizacao do
          nova_subdivisao :resto
          subdivisao_principal :resto
    
          nova_subdivisao :cofre
          nova_subdivisao :doacoes
        end
    
        credito do
          cofre "cofre inicial" => 2000.0
          doacoes "reserva para doação" => 2000.0
        end

        debito do
          cofre "investimento" => 500.0
          doacoes "criança esperança" => 1000.0
        end
      end
    end
  end

  it 'podemos adicionar e retirar de uma subdivisao' do
    subject.financeiro.subdivisoes[:cofre].valor.should == 1500.0
    subject.financeiro.subdivisoes[:doacoes].valor.should == 1000.0
  end

  it 'dado que o mês foi fechado, o que sobrou vai para a subdivisão principal' do
    subject.financeiro.subdivisoes[:resto].valor.should == 2500.0
  end
end
