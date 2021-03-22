#encoding:utf-8
require_relative 'operaciones_juego'
require 'io/console'

module Civitas

  class Vista_textual
    attr_reader :i_gestion, :i_propiedad, :juego_model
    @@separador = "====================="
    def initialize
      @juego_model
      @i_gestion=-1
      @i_propiedad=-1
    end

    def mostrar_estado(estado)
      puts estado
    end

    
    def pausa
      print "Pulsa una tecla"
      STDIN.getch
      print "\n"
    end

    def lee_entero(max,msg1,msg2)
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end



    def menu(titulo,lista)
      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l
        index += 1
      }

      opcion = lee_entero(lista.length,
                          "\n"+tab+"Elige una opción: ",
                          tab+"Valor erróneo")
      return opcion
    end

    def salir_carcel
      lista_salidas_carcel = [Salidas_carcel::TIRANDO,Salidas_carcel::PAGANDO]
      opcion = menu("Elige a forma para intentar salir de la carcel",["Tirando","Pagando"])
      
      return (lista_salidas_carcel[opcion])
    end
    
    def comprar
      lista_respuestas = [Respuestas::NO,Respuestas::SI]
      opcion = menu("Desea comprar la calle?",["NO","SI"])
      return (lista_respuestas[opcion])
      end

    def gestionar
      lista_gestiones_inmobiliarias = [Gestiones_inmobiliarias::VENDER,
      Gestiones_inmobiliarias::HIPOTECAR,Gestiones_inmobiliarias::CANCELAR_HIPOTECA,
      Gestiones_inmobiliarias::CONSTRUIR_CASA,Gestiones_inmobiliarias::CONSTRUIR_HOTEL,
      Gestiones_inmobiliarias::TERMINAR]
      
      opcion = menu("Elige la gestion inmobiliaria a realizar en su/s propiedad/es",
      ["Vender","Hipotecar","Cancelar Hipoteca","Construir Casa","Construir Hotel",
      "Terminar"])
      @i_gestion=opcion
     
      if(opcion !=5)
        propiedades = []
        for propiedad in @juego_model.get_jugador_actual.propiedades
          propiedades << propiedad.nombre
        end
        @i_propiedad=menu("Elige una de tus propiedades: ", propiedades)
      end
    end
    
    def mostrar_siguiente_operacion(operacion)
      puts("Siguiente Operacion: #{operacion.to_s}")
    end

    def mostrar_eventos
      while(Diario.instance.eventos_pendientes)
        Diario.instance.leer_evento
      end
    end

    def set_civitas_juego(civitas)
         @juego_model=civitas
         self.actualizar_vista
    end
   
    def actualizar_vista
      puts("#{@juego_model.info_jugador_texto}")
      puts("#{@juego_model.get_casilla_actual.to_string}")
    end

    
  end

end
