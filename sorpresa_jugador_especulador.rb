require_relative 'jugador_especulador.rb'

module Civitas
  class Sorpresa_jugador_especulador < Sorpresa
    def initialize(fianza,texto)
      super(texto)
      @fianza=fianza
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        especulador = Jugador_especulador.nuevo_especulador(todos.at(actual), @fianza)
        todos[actual] = especulador
      end
    end
    
    public_class_method :new
  end
end
