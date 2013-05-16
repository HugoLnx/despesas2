module Temporizacao
  FactoryGirl.define do
    factory :ano, class: Ano do
      ignore do
        numero 2012
      end

      initialize_with{ new(nil, numero) }
    end

    factory :mes, class: Mes do
      ignore do
        numero 1
      end

      initialize_with{ new(nil, numero) }
    end

    factory :anos, class: Anos do
    end

    factory :meses, class: Meses do
    end
  end
end

module Monetizacao
  FactoryGirl.define do
    factory :conta, class: Conta do
      ignore do
        nome :cofre
      end

      initialize_with{ new(nome) }
    end

    factory :contas, class: Contas do
      ignore do
        subdivisoes []
      end

      initialize_with{ new(subdivisoes) }
    end
  end
end
