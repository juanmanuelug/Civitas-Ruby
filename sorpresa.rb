require_relative 'mazo_sorpresas.rb'
require_relative 'tablero.rb'
require_relative 'casilla.rb'
require_relative 'diario.rb'

module Civitas
  class Sorpresa
    def initialize(texto)
      @texto=texto
    end
    
    def aplicar_a_jugador(actual, todos)
    end
    
    def informe(actual,todos)
      if(jugador_correcto(actual,todos))
        Diario.instance.ocurre_evento("Se aplica la sorpresa #{self.to_string} al jugador 
          #{todos.at(actual).nombre}")
      end
    end
    
    def jugador_correcto(actual,todos)
      es_correcto=false
      
      if(actual >= 0 && actual < todos.length)
        es_correcto=true
      end
      
      return es_correcto
    end

    
    def to_string
      String::new(string = "#{@texto}")
      
      return string
    end
    
    
    private :informe
    private_class_method :new
  end
end
