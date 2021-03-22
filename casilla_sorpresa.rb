
module Civitas
  class Casilla_sorpresa < Casilla
    def initialize(mazo, nombre)
      super(nombre)
      @mazo = mazo
      @sorpresa = nil
    end
    
    def recibe_jugador(iactual,todos)
      if(jugador_correcto(iactual,todos))
        informe(iactual,todos)
        @sorpresa=@mazo.siguiente
        @sorpresa.aplicar_a_jugador(iactual,todos)
      end
    end
    
    def to_string
      String::new(cadena="\n******************************\n")
      cadena+="\n " + @nombre + " | "
      cadena+="\n******************************\n"
      return cadena
    end
  end
end
