module Model
  module ColecaoNomeada
    def colecao_nomeada_para(var)
      self.class_eval do
        extend Forwardable
        include Enumerable

        def_delegators var, :push, :<<, :empty?, :each

        define_method :var do
          var
        end

        def clone
          array = instance_variable_get(var).map(&:clone)
          self.class.new(array)
        end

        def [](nome)
          instance_variable_get(var).find{|e| e.nome == nome}
        end

        def +(array)
          array = array.to_a
          self.class.new(instance_variable_get(var) + array)
        end

        def ==(collection)
          collection.is_a?(self.class) &&
          self.to_a.sort == collection.to_a.sort
        end

        def delete(nome)
          i = instance_variable_get(var).index{|e| e.nome == nome}
          instance_variable_get(var).delete_at i
        end
      end
    end
  end
end
