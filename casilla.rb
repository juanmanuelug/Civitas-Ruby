require_relative 'sorpresa.rb'
require_relative 'titulo_propiedad.rb'
module Civitas
  class Casilla
    attr_reader :nombre, :titulo_propiedad
    
    def initialize(nombre)
      @nombre=nombre
      @titulo_propiedad = nil
    end

    def informe(iactual,todos)
      Diario.instance.ocurre_evento(todos.at(iactual).to_string)
      Diario.instance.ocurre_evento(self.to_string)
    end
    
    def jugador_correcto(iactual,todos)
      bool = false
      if(iactual<todos.length && iactual>=0)
        bool=true
      end
      return bool
    end
    
    def recibe_jugador(iactual,todos)
        informe(iactual,todos)
    end
    
    def to_string
      String::new(cadena="\n******************************\n")
      cadena+="\n " + @nombre 
      cadena+="\n******************************\n"
      return cadena
    end
    
    private :informe
  end
end
