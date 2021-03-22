require_relative 'diario.rb'
require_relative 'titulo_propiedad.rb'
require_relative 'sorpresa.rb'

module Civitas
  class Jugador
    @@casas_max=4
    @@casas_por_hotel=4
    @@hoteles_max=4
    @@paso_por_salida=1000.0
    @@precio_libertad=200.0
    @@saldo_inicial=7500.0
    
    attr_reader :casas_max, :casas_por_hotel, :hoteles_max, :nombre, :num_casilla_actual,
      :precio_libertad, :paso_por_salida, :puede_comprar, :saldo, :encarcelado, :salvoconducto,
      :propiedades
    
    def initialize(nombre)
      @nombre=nombre
      @salvoconducto=nil
      @propiedades=[]
      @encarcelado=false
      @num_casilla_actual=0
      @saldo=@@saldo_inicial
      @puede_comprar=false
    end
    
    def copia(otro)
      @nombre=otro.nombre
      @encarcelado=otro.encarcelado
      @num_casilla_actual=otro.num_casilla_actual
      @puede_comprar=otro.puede_comprar
      @saldo=otro.saldo
      @salvoconducto=otro.salvoconducto
      @propiedades=otro.propiedades
    end
    
    def cancelar_hipoteca(ip)
      result = false
      
      if(!@encarcelado)
        if(existe_la_propiedad(ip))
          propiedad=@propiedades.at(ip)
          cantidad=propiedad.get_importe_cancelar_hipoteca
          puedo_gastar=puedo_gastar(cantidad)
          if(puedo_gastar)
            result=propiedad.cancelar_hipoteca(self)
            if(result)
              Diario.instance.ocurre_evento("El jugador #{@nombre} cancela la hipoteca
                 de la propiedad: '#{propiedad.nombre}'")
            end
          end
        end
      end
      
      return result
    end
    
    def cantidad_casas_hoteles
      cantidad=0
      
      for i in (0..@propiedades.length-1)
        cantidad += @propiedades.at(i).cantidad_casas_hoteles
      end
      
      return cantidad
    end
    
    def compare_to(otro)
      return @saldo <=> otro.saldo
    end
    
    def comprar(titulo)
      result = false
      
      if(!@encarcelado)
        if(@puede_comprar)
          precio=titulo.precio_compra
          if(puedo_gastar(precio))
            result=titulo.comprar(self)
            if(result)
              @propiedades << titulo
              Diario.instance.ocurre_evento("El jugador #{@nombre} ha comprado 
                            la propiedad: '#{titulo.nombre}'")
            end
            @puede_comprar=false
          end
        end
      end
      
      return result
    end
    
    def construir_casa(ip)
      result = false
      
      if(!@encarcelado)
        if(existe_la_propiedad(ip))
          propiedad=@propiedades.at(ip)
          puedo_edificar_casa=false
          precio=propiedad.precio_edificar
          if(puedo_gastar(precio))
            puedo_edificar_casa=puedo_edificar_casa(propiedad)
          end
          if(puedo_edificar_casa)
            result=propiedad.construir_casa(self)
            if(result)
              Diario.instance.ocurre_evento("El jugador #{@nombre} construye casa
               en la propiedad: '#{propiedad.nombre}'")
            end
          end
        end
      end
      
      return result
    end
    
    def construir_hotel(ip)
      result = false
      
      if(!@encarcelado)
        if(existe_la_propiedad(ip))
          propiedad=@propiedades.at(ip)
          puedo_edificar_hotel=false
          precio=propiedad.precio_edificar
          if(puedo_gastar(precio))
            puedo_edificar_hotel=puedo_edificar_hotel(propiedad)
          end
          if(puedo_edificar_hotel)
            result=propiedad.construir_hotel(self)
            casas_por_hotel=@@casas_por_hotel
            propiedad.derruir_casas(casas_por_hotel, self)
            Diario.instance.ocurre_evento("El jugador #{@nombre} construye hotel
               en la propiedad: '#{propiedad.nombre}'")
          end
        end
      end
      
      return result
    end
    
    def debe_ser_encarcelado
      ser_encarcelado=false
      
      if (!@encarcelado)
        if(!tiene_salvoconducto)
          ser_encarcelado=true
        else
          perder_salvoconducto
          Diario.instance.ocurre_evento("El jugador #{@nombre} usa su salvoconducto 
                        y se libra de la carcel")
        end
      end
      
      return ser_encarcelado
    end
    
    def en_bancarrota
      return (@saldo < 0)
    end
    
    def encarcelar(num_casilla_carcel)
      if(debe_ser_encarcelado)
        @encarcelado=mover_a_casilla(num_casilla_carcel)
        if(@encarcelado)
          Diario.instance.ocurre_evento("El jugador #{@nombre} es encarcelado")
        end
      end
      
      return @encarcelado
    end
    
    def existe_la_propiedad(ip)
      return (@propiedades.at(ip) != nil)
    end
    
    def hipotecar(ip)
      result = false
      
      if(!@encarcelado)
        if(existe_la_propiedad(ip))
          propiedad=@propiedades.at(ip)
          result=propiedad.hipotecar(self)
          if(result)
            Diario.instance.ocurre_evento("El jugador #{@nombre} hipoteca la 
              propiedad: '#{propiedad.nombre}'")
          end
        end
      end
      
      return result
    end
    
    def modificar_saldo(cantidad)
      @saldo += cantidad
      Diario.instance.ocurre_evento("El jugador #{@nombre} sufre
                    una modificacion en su saldo (#{cantidad}")
      
      return true
    end
    
    def mover_a_casilla(num_casilla)
      resultado=false
      
      if !@encarcelado
        @num_casilla_actual=num_casilla
        @puede_comprar=false
        Diario.instance.ocurre_evento("El jugador #{@nombre} se mueve a la casilla #{num_casilla}")
        resultado=true
      end
      
      return resultado
    end
    
    def obtener_salvoconducto(sorpresa)
      obtiene=false
      
      if !@encarcelado
        @salvoconducto=sorpresa
        obtiene=true
      end
      
      return obtiene
    end
    
    def paga(cantidad)
      return modificar_saldo(cantidad*(-1))
    end
    
    def paga_alquiler(cantidad)
      resultado=false
      
      if !@encarcelado
        resultado=paga(cantidad)
      end
      
      return resultado
    end
    
    def paga_impuesto(cantidad)
      resultado=false
      
      if !@encarcelado
        resultado=paga(cantidad)
      end
      
      return resultado
    end
    
    def pasa_por_salida
      modificar_saldo(@@paso_por_salida)
      
      Diario.instance.ocurre_evento("El jugador #{@nombre} pasa por la salida")
      
      return true
    end
    
    def perder_salvoconducto
      @salvoconducto.usada
      @salvoconducto=nil
    end
    
    def puede_comprar_casilla
      if @encarcelado
        @puede_comprar=false
      else
        @puede_comprar=true
      end
      
      return @puede_comprar
    end
    
    def puede_salir_carcel_pagando
      return (@saldo >= @@precio_libertad)
    end
    
    def puedo_edificar_casa(propiedad)
      return (puedo_gastar(propiedad.precio_edificar) && propiedad.num_casas < @@casas_max)
    end
    
    def puedo_edificar_hotel(propiedad)
      return (propiedad.num_hoteles < @@hoteles_max && propiedad.num_casas >= @@casas_por_hotel)
    end
    
    def puedo_gastar(precio)
      return (!@encarcelado && @saldo >= precio)
    end
    
    def recibe(cantidad)
      resultado=false
      
      if !@encarcelado
        resultado=modificar_saldo(cantidad)
      end
      
      return resultado
    end
    
    def salir_carcel_pagando
      resultado=false
      
      if(@encarcelado && puede_salir_carcel_pagando)
        paga(@@precio_libertad)
        @encarcelado=false
        Diario.instance.ocurre_evento("El jugador #{@nombre} sale de la carcel pagando")
        resultado=true
      end
      
      return resultado
    end
    
    def salir_carcel_tirando
      resultado=false
      
      if(@encarcelado && Dado.instance.salgo_de_la_carcel)
        @encarcelado = false
        Diario.instance.ocurre_evento("El jugador #{@nombre} sale de la carcel pagando")
        resultado=true
      end
      
      return resultado
    end
    
    def tiene_algo_que_gestionar
      return (@propiedades.length > 0)
    end
    
    def tiene_salvoconducto
      return (@salvoconducto != nil)
    end
    
    def to_string
      String::new(mensaje="******************************\n")
      mensaje += @nombre + "\n******************************\n"
      mensaje += " Encarcelado = #{@encarcelado.to_s}"
      mensaje += "\n Numero Casilla Actual= #{@num_casilla_actual}         Saldo= #{@saldo}"
      mensaje += "\n Puede comprar =  #{@puede_comprar.to_s}"
      if(@salvoconducto != nil)
        mensaje += "\n Salvoconducto = true"
      else
        mensaje += "\n Salvoconducto = false"
      end
      mensaje += "\n******************************\n"
      
      return mensaje
    end
    
    def vender(ip)
      resultado=false
      
      if !@encarcelado
        if (existe_la_propiedad(ip))
          propiedad=@propiedades.at(ip)
          resultado=propiedad.vender(self)
          if(resultado)
            @propiedades.delete_at(ip)
            Diario.instance.ocurre_evento("El jugador #{@nombre} ha vendido la
                          propiedad: '#{propiedad.nombre}'")
          end
        end
      end
      
      return resultado
    end
    
    private :existe_la_propiedad, :perder_salvoconducto, :puede_salir_carcel_pagando,
      :puedo_edificar_casa, :puedo_edificar_hotel, :puedo_gastar
  end
end