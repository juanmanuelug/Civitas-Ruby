module Civitas
  class Sorpresa_por_jugador < Sorpresa
    
    def initialize(valor,texto)
      super(texto)
      @valor=valor
    end
    
    def aplicar_a_jugador
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        pagar=Sorpresa_pagar_cobrar.new_resto((@valor*(-1)), "Pagar")
        for i in (0..todos.length-1)
          if(todos.at(i) != todos.at(actual))
            pagar.aplicar_a_jugador(i,todos)
          end
        end
        cobrar=Sorpresa_pagar_cobrar.new_resto((@valor*(todos.length-1)), "Cobrar")
        cobrar.aplicar_a_jugador(actual,todos)
      end
    end
    
    public_class_method :new
  end
end
