# encoding: utf-8
bigbang do
  ano 2012 do
    julho do
      organizacao do
        nova_subdivisao :resto
        subdivisao_principal :resto
  
        nova_subdivisao :cofre
        nova_subdivisao :doacoes
      end
  
      credito do
        resto "resto inicial" => 1000.0
        cofre "cofre inicial" => 2000.0
      end
    end
  
    agosto do
      organizacao do
        novas_subdivisoes(
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
      end
    end
  end
end
