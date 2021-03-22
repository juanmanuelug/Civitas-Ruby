module Civitas
  class Sorpresa_salir_carcel < Sorpresa
    
    def initialize(mazo,texto)
      super(texto)
      @mazo=mazo
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        encontrado=false
        for i in (0..todos.length-1)
          if(todos.at(i).tiene_salvoconducto)
            encontrado=true
          end
        end
        if !encontrado
          todos.at(actual).obtener_salvoconducto(self)
          salir_del_mazo
        end
      end      
    end
    
    def salir_del_mazo
      @mazo.inhabilitar_carta_especial(self)
    end
    
    def usada
      @mazo.habilitar_carta_especial(self)
    end
    
    public_class_method :new
  end
end
