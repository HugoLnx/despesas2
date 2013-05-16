# encoding: utf-8
require 'spec_helper'

describe "agendamento mensal" do
  context "em uma conta" do
    context "débito" do
      bigbang do
        ano 2012 do
          janeiro do
            organizacao do
              nova_conta :cofre
            end
        
            credito do
              cofre "inicial" => 5000.0
            end

            debito do
              mensal "desconto", cofre: 1000.0
              mensal_pago "desconto"
            end
          end

          fevereiro do
          end
        end
      end

      it "debita todo mês" do
        ano = subject.anos[2012]
        ano.meses[:janeiro].financeiro.contas[:cofre].valor.should == 4000.0
        ano.meses[:fevereiro].financeiro.contas[:cofre].valor.should == 3000.0
      end

      it 'pode-se marcar como pago' do
        ano = subject.anos[2012]
        debitos_pendentes = ano.meses[:janeiro].debitos_pendentes.map(&:first)
        debitos_pendentes.should_not include "desconto"
      end

      it 'inicialmente é marcado como pendente, ou não-pago' do
        ano = subject.anos[2012]
        debitos_pendentes = ano.meses[:fevereiro].debitos_pendentes.map(&:first)
        debitos_pendentes.should include "desconto"
      end
    end
  end

  context "no total" do
    context "crédito" do
      bigbang do
        ano 2012 do
          janeiro do
            organizacao do
              nova_conta :cofre
            end
        
            credito do
              mensal "salario" => 2000.0
            end
          end

          fevereiro do
          end
        end
      end

      it "credita todo mês" do
        ano = subject.anos[2012]
        ano.meses[:janeiro].financeiro.principal.valor.should == 2000.0
        ano.meses[:fevereiro].financeiro.principal.valor.should == 4000.0
      end
    end

    context "debito" do
      bigbang do
        ano 2012 do
          janeiro do
            organizacao do
              nova_conta :cofre
            end

            credito do
              total "salario" => 5000.0
            end

            debito do
              mensal "desconto" => 1000.0
              mensal_pago "desconto"
            end
          end

          fevereiro do
          end
        end
      end

      it "debita todo mês" do
        ano = subject.anos[2012]
        ano.meses[:janeiro].financeiro.principal.valor.should == 4000.0
        ano.meses[:fevereiro].financeiro.principal.valor.should == 3000.0
      end

      it 'pode-se marcar como pago' do
        ano = subject.anos[2012]
        debitos_pendentes = ano.meses[:janeiro].debitos_pendentes.map(&:first)
        debitos_pendentes.should_not include "desconto"
      end

      it 'inicialmente é marcado como pendente, ou não-pago' do
        ano = subject.anos[2012]
        debitos_pendentes = ano.meses[:fevereiro].debitos_pendentes.map(&:first)
        debitos_pendentes.should include "desconto"
      end
    end
  end
end
