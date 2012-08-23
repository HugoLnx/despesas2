module DSL
  class Contexto < Module
    def initialize(*args, &block)
      self.instance_eval do
        extend self
      end

      super(*args, &block)
    end
  end
end
