# encoding: utf-8
bigbang do
  ano 2012 do
    julho fechou: 5000.0 do
      organizacao do
        nova_conta :cofre
        nova_conta :doacoes
      end
  
      credito do
        cofre "cofre inicial" => 2000.0
      end
    end
  
    agosto do
      organizacao do
        novas_contas(
          :saude, :presentes,
          :roupas, :lazer,
          :aposentadoria
        )
  
        padroes(
          cofre: "%15",
          doacoes: "%15",
          saude: 100.0,
          presentes: 100.0,
          roupas: 100.0,
          lazer: 200.0,
          aposentadoria: "10%"
        )
      end
  
      credito do
        mensal "salario estagio" => 1000.0
      end
  
      debito do
        mensal "ajuda lar" => "%10"
        mensal "daniel cristóvão", doacoes: 50.0
        mensal "anália franco", doacoes: 25.0

        emprestado(
          para: :fulano,
          descricao: "fulano não 71",
          quantidade: 300.0,
          jah_esta_incluido_no_total: true
        )
      end

      setembro do
        credito do
          devolveu fulano: 200
        end
      end

      outubro do
        credito do
          devolveu :fulano
        end
      end
    end
  end
end
