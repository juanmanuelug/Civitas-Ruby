module Civitas
  class Casilla_calle < Casilla
    def initialize(titulo)
      super(titulo.nombre);
      @titulo_propiedad = titulo
    end
    
    def recibe_jugador(iactual,todos)
      if(jugador_correcto(iactual,todos))
        informe(iactual,todos)
        jugador=todos.at(iactual)
        if(!@titulo_propiedad.tiene_propietario)
          jugador.puede_comprar_casilla
        else
          @titulo_propiedad.tramitar_alquiler(jugador)
        end
      end
    end
    
    def to_string
      String::new(cadena=@titulo_propiedad.to_string)
      return cadena
    end
  end
end
