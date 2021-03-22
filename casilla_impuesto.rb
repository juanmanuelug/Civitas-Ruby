module Civitas
  class Casilla_impuesto < Casilla
    def initialize(cantidad, nombre)
      super(nombre);
      @importe = cantidad
    end
    
    def recibe_jugador(iactual,todos)
      if(jugador_correcto(iactual,todos))
        informe(iactual,todos)
        todos.at(iactual).paga_impuesto(@importe)
      end
    end
    
    def to_string
      String::new(cadena="\n******************************\n")
      cadena+="\n " + @nombre + " | Importe #{@importe}"
      cadena+="\n******************************\n"
      return cadena
    end
  end
end
