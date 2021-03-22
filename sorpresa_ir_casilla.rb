# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_ir_casilla < Sorpresa
    def initialize(tablero,valor,texto)
      super(texto)
      @tablero=tablero
      @valor=valor
    end
    
    def aplicar_a_jugador(actual,todos)
      if(jugador_correcto(actual,todos))
        informe(actual,todos)
        jugador_actual=todos.at(actual)
        tirada=@tablero.calcular_tirada(jugador_actual.num_casilla_actual, @valor)
        posicion_nueva = @tablero.nueva_posicion(jugador_actual.num_casilla_actual, tirada)
        jugador_actual.mover_a_casilla(posicion_nueva)
        @tablero.get_casilla(posicion_nueva).recibe_jugador(actual,todos)
      end
    end
    
    public_class_method :new
  end
end
