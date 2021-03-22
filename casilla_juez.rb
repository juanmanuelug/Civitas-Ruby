
module Civitas
  class Casilla_juez < Casilla
    def initialize(num_casilla_carcel,nombre)
      super(nombre)
      @carcel = num_casilla_carcel
    end
    
    def recibe_jugador(iactual,todos)
      if(jugador_correcto(iactual,todos))
        informe(iactual,todos)
        todos.at(iactual).encarcelar(@carcel)
      end
    end
    
    def to_string
      String::new(cadena="\n******************************\n")
      cadena+="\n " + @nombre + " | A LA CARCEL (#{@carcel})"
      cadena+="\n******************************\n"
      return cadena
    end
  end
end
