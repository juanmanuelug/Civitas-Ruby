require_relative 'estados_juego.rb'
require_relative 'jugador.rb'
require_relative 'jugador_especulador.rb'
require_relative 'gestor_estados.rb'
require_relative 'titulo_propiedad.rb'
require_relative 'mazo_sorpresas.rb'
require_relative 'tablero.rb'
require_relative 'casilla.rb'
require_relative 'casilla_calle.rb'
require_relative 'casilla_impuesto.rb'
require_relative 'casilla_juez.rb'
require_relative 'casilla_sorpresa.rb'
require_relative 'sorpresa.rb'
require_relative 'sorpresa_pagar_cobrar.rb'
require_relative 'sorpresa_ir_carcel.rb'
require_relative 'sorpresa_ir_casilla.rb'
require_relative 'sorpresa_jugador_especulador.rb'
require_relative 'sorpresa_por_casa_hotel.rb'
require_relative 'sorpresa_por_jugador.rb'
require_relative 'sorpresa_salir_carcel.rb'
require_relative 'operaciones_juego.rb'
module Civitas
  class Civitas_juego
    attr_reader :tablero
    
    def initialize(nombres)
      @jugadores=Array.new
      for i in (0..nombres.length-1)
        jugador_nuevo=Jugador.new(nombres.at(i))
        @jugadores << jugador_nuevo
      end
      @gestor_estados=Gestor_estados.new
      @estado=@gestor_estados.estado_inicial
      @indice_jugador_actual=Dado.instance.quien_empieza(nombres.length)
      @mazo=Mazo_sorpresas.new
      @tablero=Tablero.new(0)
      inicializar_tablero(@mazo)
      inicializar_mazo_sorpresas(@tablero)
    end

    def avanza_jugador
      jugador_actual=@jugadores.at(@indice_jugador_actual)
      posicion_actual = jugador_actual.num_casilla_actual
      tirada=Dado.instance.tirar
      posicion_nueva=@tablero.nueva_posicion(posicion_actual, tirada)
      casilla=@tablero.get_casilla(posicion_nueva)
      contabilizar_pasos_por_salida(jugador_actual)
      jugador_actual.mover_a_casilla(posicion_nueva)
      casilla.recibe_jugador(@indice_jugador_actual, @jugadores)
      contabilizar_pasos_por_salida(jugador_actual)
    end
    
    def cancelar_hipoteca(ip)
      return @jugadores.at(@indice_jugador_actual).cancelar_hipoteca(ip)
    end
    
    def comprar
      jugador_actual=@jugadores.at(@indice_jugador_actual)
      num_casilla_actual=jugador_actual.num_casilla_actual
      casilla=@tablero.get_casilla(num_casilla_actual)
      titulo=casilla.titulo_propiedad
      res=jugador_actual.comprar(titulo)
      
      return res
    end
    
    def construir_casa(ip)
      return @jugadores.at(@indice_jugador_actual).construir_casa(ip)
    end
    
    def construir_hotel(ip)
      return @jugadores.at(@indice_jugador_actual).construir_hotel(ip)
    end
    
    def contabilizar_pasos_por_salida(jugador_actual)
      salida=@tablero.get_por_salida
      while salida>0
        jugador_actual.pasa_por_salida
        salida-=1
      end
    end
    
    def final_del_juego
      bool=false
      for i in (0..@jugadores.length-1)
        if(@jugadores.at(i).en_bancarrota)
          bool=true
        end
      end
      return bool
    end
    
    def get_casilla_actual
      casilla_actual=@jugadores.at(@indice_jugador_actual).num_casilla_actual
      return @tablero.get_casilla(casilla_actual)
    end
    
    def get_jugador_actual
      return @jugadores.at(@indice_jugador_actual)
    end
    
    def hipotecar(ip)
      return @jugadores.at(@indice_jugador_actual).hipotecar(ip)
    end
    
    def info_jugador_texto      
      return get_jugador_actual.to_string
    end
    
    def inicializar_mazo_sorpresas(tablero)
        #Sorpresa 1
        cobrar=Sorpresa_pagar_cobrar.new(500,"Te pagan 500 euros por un premio al informatico con menos futuro")
        @mazo.al_mazo(cobrar)
        #Sorpresa 2
        pagar=Sorpresa_pagar_cobrar.new(-500,"Mensaje de un numero privado\n******************\n HAS GANADO UN IPHONE 11\nIntroduce tus datos de la tarjeta de credito para reclamarlo\n******************\n Pierdes 500 euros")
        @mazo.al_mazo(pagar)
        #Sorpresa 3
        ir_casilla1=Sorpresa_ir_casilla.new(tablero,6,"Vas a la casilla del Palenque")
        @mazo.al_mazo(ir_casilla1)
        #Sorpresa 4
        ir_casilla2=Sorpresa_ir_casilla.new(tablero,11,"Te mueves a la casilla Avenida del Ejercito")
        @mazo.al_mazo(ir_casilla2)
        #Sorpresa 5
        ir_casilla3=Sorpresa_ir_casilla.new(tablero,10,"Te desplazas a la carcel de chill")
        @mazo.al_mazo(ir_casilla3)
        #Sorpresa 6
        casa_hotel1=Sorpresa_por_casa_hotel.new(-100,"Hacienda viene a cobrar tus propiedades bro")
        @mazo.al_mazo(casa_hotel1)
        #Sorpresa 7
        casa_hotel2=Sorpresa_por_casa_hotel.new(100,"Hacienda te paga por tus casitas y hoteles")
        @mazo.al_mazo(casa_hotel2)
        #Sorpresa 8
        cobrar_jugador=Sorpresa_por_jugador.new(100,"Has tenido suerte y tus panas te invitan a unas copas")
        @mazo.al_mazo(cobrar_jugador)
        #Sorpresa 9 
        pagar_jugador=Sorpresa_por_jugador.new(-100,"Que mal, te toca pagar las copas de tus panas")
        @mazo.al_mazo(pagar_jugador)
        #Sorpresa 10
        salir_carcel=Sorpresa_salir_carcel.new(@mazo,"Un salvoconducto para ti bro")
        @mazo.al_mazo(salir_carcel)
        #Sorpresa 11
        ir_carcel=Sorpresa_ir_carcel.new(tablero,"Te encarcelan por evadir impuestos")
        @mazo.al_mazo(ir_carcel)
        #Sorpresa 12
        especulador=Sorpresa_jugador_especulador.new(150,"Te conviertes en Jugador Especulador")
        @mazo.al_mazo(especulador)
    end
    
    
    def inicializar_tablero(mazo)
      casilla_carcel=10
      #Salida y Carcel
      @tablero=Tablero.new(casilla_carcel)
      #Calle 1
      uno=Titulo_propiedad.new("Calle Gibraltar",55,4,400,400,550)
      calle_gibraltar=Casilla_calle.new(uno)
      @tablero.aniade_casilla(calle_gibraltar)
      #Calle 2
      dos=Titulo_propiedad.new("Calle Canarias",75,5,500,500,675)
      calle_canarias=Casilla_calle.new(dos)
      @tablero.aniade_casilla(calle_canarias)
      #Calle 3
      tres=Titulo_propiedad.new("La Atunara",95,6,520,520,750)
      atunara=Casilla_calle.new(tres)
      @tablero.aniade_casilla(atunara)
      #Sorpresa 1
      mazo1=Casilla_sorpresa.new(mazo,"Sorpresa 1")
      @tablero.aniade_casilla(mazo1)
      #Calle 4
      cuatro=Titulo_propiedad.new("Avenida Maria Guerrero",100,7,575,575,900)
      avenida_maria_guerrero=Casilla_calle.new(cuatro)
      @tablero.aniade_casilla(avenida_maria_guerrero)
      #Calle 5
      cinco=Titulo_propiedad.new("El Palenque",120,8,600,600,1000)
      el_palenque=Casilla_calle.new(cinco)
      @tablero.aniade_casilla(el_palenque)
      #Impuesto
      impuesto=Casilla_impuesto.new(1000,"Hacienda")
      @tablero.aniade_casilla(impuesto)
      #Calle 6
      seis=Titulo_propiedad.new("El Zabal",155,9,650,650,1200)
      el_zabal=Casilla_calle.new(seis)
      @tablero.aniade_casilla(el_zabal)
      #Calle 7
      siete=Titulo_propiedad.new("Calle Larga",200,10,680,680,1300)
      calle_tabarca=Casilla_calle.new(siete)
      @tablero.aniade_casilla(calle_tabarca)
      #Carcel(posicion 10)
      #Calle 8
      ocho=Titulo_propiedad.new("Avenida del Ejercito",225,11,725,725,1450)
      avenida_del_ejercito=Casilla_calle.new(ocho)
      @tablero.aniade_casilla(avenida_del_ejercito)
      #Sorpresa 2
      mazo2=Casilla_sorpresa.new(mazo,"Sorpresa 2")
      @tablero.aniade_casilla(mazo2)
      #Juez
      @tablero.aniade_juez
      #Calle 9
      nueve=Titulo_propiedad.new("Cruz Herrera",260,11,850,850,1900)
      cruz_herrera=Casilla_calle.new(nueve)
      @tablero.aniade_casilla(cruz_herrera)
      #Calle 10
      diez=Titulo_propiedad.new("Venta Melchor",450,14,1000,1000,2200)
      v_melchor=Casilla_calle.new(diez)
      @tablero.aniade_casilla(v_melchor)
      #Descanso
      descanso=Casilla.new("Burguer King")
      @tablero.aniade_casilla(descanso)
      #Calle 11
      once=Titulo_propiedad.new("Santa Margarita",750,20,1500,1500,2800)
      s_margarita=Casilla_calle.new(once)
      @tablero.aniade_casilla(s_margarita)
      #Sorpresa 3
      mazo3=Casilla_sorpresa.new(mazo,"Sorpresa 2")
      @tablero.aniade_casilla(mazo3)
      #Calle 12
      doce=Titulo_propiedad.new("La Alcaidesa",1000,25,2200,2200,4000)
      alcaidesa=Casilla_calle.new(doce)
      @tablero.aniade_casilla(alcaidesa)
    end    
    
    def pasar_turno
      if(@indice_jugador_actual<@jugadores.length-1)
        @indice_jugador_actual+=1
      else
        @indice_jugador_actual=0
      end
    end
    
    def ranking
      clasificacion=[]
      saldos=[]
      
      for i in (0..@jugadores.length-1)
        saldos[i]=@jugadores.at(i).saldo
      end
      #Ordenamos los saldos
      saldos.sort
      contador_i=@jugadores.length
      sigue=true
      while (contador_i>=0)
        contador_j=0
        #Buscamos el jugador con ese saldo
        while (contador_j<@jugadores.length && sigue)
          if(saldos[contador_j]==@jugadores.at(contador_j).saldo)
            clasificacion << @jugadores.at(contador_j)
            sigue=false
          end
          contador_j+=1
        end
        contador_i=contador_i-1
      end
      return clasificacion
    end
    
    def salir_carcel_pagando
      return @jugadores.at(@indice_jugador_actual).salir_carcel_pagando
    end
    
    def salir_carcel_tirando
      return @jugadores.at(@indice_jugador_actual).salir_carcel_tirando
    end
    
    def siguiente_paso
      jugador_actual=@jugadores.at(@indice_jugador_actual)
      operacion=@gestor_estados.operaciones_permitidas(jugador_actual,@estado)
      
      if(operacion==Operaciones_juego::PASAR_TURNO)
        pasar_turno
        siguiente_paso_completado(operacion)
        
      elsif(operacion==Operaciones_juego::AVANZAR)
        avanza_jugador
        siguiente_paso_completado(operacion)
      end
      return operacion
    end
    
    def siguiente_paso_completado(operacion)
      actual=get_jugador_actual
      @estado=@gestor_estados.siguiente_estado(actual,@estado,operacion)
    end
    
    def vender(ip)
      return @jugadores.at(@indice_jugador_actual).vender(ip)
    end
    
    private :avanza_jugador,  :inicializar_mazo_sorpresas,  :inicializar_tablero,
      :pasar_turno
  end
end
