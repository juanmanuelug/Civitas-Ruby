module Civitas
  class Sorpresa_por_casa_hotel < Sorpresa
    
    def initialize(valor,texto)
      super(texto)
      @valor=valor
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        todos.at(actual).modificar_saldo(@valor*todos.at(actual).cantidad_casas_hoteles)
      end
    end
    
    public_class_method :new
  end
end
