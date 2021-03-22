# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Civitas
  class Sorpresa_ir_carcel < Sorpresa
    
      def initialize(tablero,texto)
        super(texto)
        @tablero=tablero
      end
      
      def aplicar_a_jugador(actual,todos)
        if(jugador_correcto(actual,todos))
          informe(actual,todos)
          todos.at(actual).encarcelar(@tablero.num_casilla_carcel)
        end        
      end
      
      public_class_method :new
  end
end
