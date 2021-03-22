require_relative 'civitas_juego.rb'
require_relative 'gestiones_inmobiliarias.rb'
require_relative 'operaciones_juego.rb'
require_relative 'respuestas.rb'
require_relative 'operacion_inmobiliaria.rb'
require_relative 'salidas_carcel.rb'

module Civitas
  class Controlador
    def initialize(juego, vista)
      @juego=juego
      @vista=vista
    end
    
    def juega
      @vista.set_civitas_juego(@juego)
      while(!@juego.final_del_juego)
        @vista.actualizar_vista
        @vista.pausa
        
        op = @juego.siguiente_paso
        @vista.mostrar_siguiente_operacion(op)
        if(!(op==Operaciones_juego::PASAR_TURNO))
          @vista.mostrar_eventos
        end
        
        if(!@juego.final_del_juego)
          if(op==Operaciones_juego::COMPRAR)
            res = @vista.comprar
            if(res==Respuestas::SI)
              @juego.comprar()
            end
            @juego.siguiente_paso_completado(op)
          elsif(op==Operaciones_juego::GESTIONAR)
            @vista.gestionar
            case @vista.i_gestion
            when 0
              gestion = Gestiones_inmobiliarias::VENDER
              operacion = Operacion_inmobiliaria.new(gestion, @vista.i_propiedad)
              @juego.vender(@vista.i_propiedad)
            when 1
              gestion = Gestiones_inmobiliarias::HIPOTECAR
              operacion = Operacion_inmobiliaria.new(gestion, @vista.i_propiedad)
              @juego.hipotecar(@vista.i_propiedad)
            when 2
              gestion = Gestiones_inmobiliarias::CANCELAR_HIPOTECA
              operacion = Operacion_inmobiliaria.new(gestion, @vista.i_propiedad)
              @juego.cancelar_hipoteca(@vista.i_propiedad)
            when 3
              gestion = Gestiones_inmobiliarias::CONSTRUIR_CASA
              operacion = Operacion_inmobiliaria.new(gestion, @vista.i_propiedad)
              @juego.construir_casa(@vista.i_propiedad)
            when 4
              gestion = Gestiones_inmobiliarias::CONSTRUIR_HOTEL
              operacion = Operacion_inmobiliaria.new(gestion, @vista.i_propiedad)
              construido = @juego.construir_hotel(@vista.i_propiedad)
              if(!construido)
                puts("No se puede construir hotel")
              end
            else
              gestion = Gestiones_inmobiliarias::TERMINAR
              operacion = Operacion_inmobiliaria.new(gestion, @vista.i_propiedad)
              @juego.siguiente_paso_completado(op)
            end
          elsif(op==Operaciones_juego::SALIR_CARCEL)
            salida = @vista.salir_carcel
            if(salida==Salidas_carcel::PAGANDO)
              @juego.salir_carcel_pagando
            else
              @juego.salir_carcel_tirando
            end
            @juego.siguiente_paso_completado(op)
          end
        else
          @juego.final_del_juego
        end
      end
      ranking = @juego.ranking
      puts @juego.ranking.inspect
      puts("\n\n*****CLASIFICACION FINAL*****\n")
      i=1
      for j in (0..ranking.length-1)
        puts("\n#{i} PUESTO")
        puts("\n#{ranking[j].to_string}")
        i+=1
      end
      puts("\nGRACIAS POR JUGAR :)")
    end
  end
end
