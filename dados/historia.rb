ano 2012 do
  julho do
    organizacao do
      nova_subdivisao :resto
      subdivisao_principal :resto

      nova_subdivisao :cofre
      nova_subdivisao :doacoes
    end

    credito do
      resto 1936.0
      cofre 2835.0
    end
  end

  agosto do
    organizacao do
      novas_subdivisoes(
        :saude, :presentes,
        :roupas, :lazer
      )

      padroes(
        cofre: "%15",
        doacoes: "%15",
        saude: 100.0,
        presentes: 100.0,
        roupas: 100.0,
        lazer: 200.0
      )
    end

    credito do
      mensal salario: 1160.0
    end

    debito do
      mensal lar: "%10"
    end
  end
end
