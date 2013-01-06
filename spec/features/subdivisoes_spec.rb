# encoding: utf-8
require 'spec_helper'

describe "subdivisoes" do
  describe "operações básicas" do
    bigbang do
      ano 2012 do
        janeiro do
          organizacao do
            nova_subdivisao :resto
            subdivisao_principal :resto

            nova_subdivisao :cofre
          end
      
          credito do
            cofre "cofre inicial" => 2000.0
          end

          debito do
            cofre "investimento" => 500.0
          end
        end
      end
    end

    it "crédito e débito unitário" do
      subject.financeiro.subdivisoes[:cofre].valor.should == 1500.0
    end
  end

  describe "subdivisao principal" do
    context "em mes fechado" do
      bigbang do
        ano 2012 do
          janeiro fechou: 5000.0 do
            organizacao do
              nova_subdivisao :resto
              subdivisao_principal :resto
        
              nova_subdivisao :cofre
            end
        
            credito do
              cofre "cofre inicial" => 3000.0
            end

            debito do
              cofre "investimento" => 1000.0
            end
          end
        end
      end

      it %q{considera o valor fechado como o total do momento,
            então diminui-se os debitos e o que sobrou será o valor
            da subdivisão principal} do
        subject.financeiro.subdivisoes[:resto].valor.should == 3000.0
      end
    end


    context "em mes aberto" do
      bigbang do
        ano 2012 do
          janeiro do
            organizacao do
              nova_subdivisao :resto
              subdivisao_principal :resto
        
              nova_subdivisao :cofre
            end
        
            credito do
              cofre "cofre inicial" => 1000.0
            end

            debito do
              cofre "investimento" => 200.0
            end
          end
        end
      end

      it 'o resto será o que foi creditado menos o que foi debitado' do
        pending "falhando, por enquanto"
        subject.financeiro.subdivisoes[:resto].valor.should == 800.0
      end
    end
  end

  describe "credito automatico" do
    bigbang do
      ano 2012 do
        janeiro do
          organizacao do
            nova_subdivisao :resto
            subdivisao_principal :resto
      
            nova_subdivisao :cofre

            padrao cofre: 1000.0
          end
        end

        fevereiro do
        end
      end
    end

    it "credita todo mês" do
      ano = subject.anos[2012]
      ano.meses[:janeiro].financeiro.subdivisoes[:cofre].valor.should == 1000.0
      ano.meses[:fevereiro].financeiro.subdivisoes[:cofre].valor.should == 2000.0
    end
  end


  describe "credito automatico com porcentagem" do
    bigbang do
      ano 2012 do
        janeiro do
          organizacao do
            nova_subdivisao :resto
            subdivisao_principal :resto
      
            nova_subdivisao :cofre

            padrao cofre: "10%"
          end

          credito do
            total "salario" => 100.0
          end
        end

        fevereiro do
          credito do
            total "salario" => 200.0
          end
        end
      end
    end

    it "calcula a porcentagem baseada no total creditado do mês" do
      ano = subject.anos[2012]
      ano.meses[:janeiro].financeiro.subdivisoes[:cofre].valor.should == 10.0
      ano.meses[:fevereiro].financeiro.subdivisoes[:cofre].valor.should == 30.0
    end
  end
end
