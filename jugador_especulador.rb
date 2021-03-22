require_relative 'jugador.rb'

module Civitas
  class Jugador_especulador < Jugador
    @@factor_especulador = 2
    
    def initialize(fianza)
      @fianza = fianza
    end
    
    def self.nuevo_especulador(jugador, fianza)
      especulador = self.new(fianza)
      especulador.copia(jugador)
      
      for i in 0..jugador.propiedades.length-1
        jugador.propiedades.at(i).actualizar_propietario_por_conversion(especulador)
      end
      
      return especulador
    end
    
    def get_hoteles_max
        return(@@hoteles_max * @@factor_especulador)
    end

    def get_casas_max
      return(@@casas_max * @@factor_especulador)
    end

    def puede_pagar_fianza
      return(@saldo >= @fianza)
    end

    def paga_fianza
      result = false

      if(puede_pagar_fianza)
        modificar_saldo((-1)*@fianza)
        result=true
      end

      return result
    end
      
    def debe_ser_encarcelado
      ser_encarcelado = false

      if(super)
        if(!puede_pagar_fianza)
          ser_encarcelado = true
        else
          paga_fianza
          Diario.instance.ocurre_evento("El jugador especulador #{@nombre}
                         paga la fianza y evita la carcel")
        end
      end

      return ser_encarcelado
    end
    
    def puedo_edificar_casa(propiedad)
      return(puedo_gastar(propiedad.precio_edificar) && propiedad.num_casas < get_casas_max)
    end

    def puedo_edificar_hotel(propiedad)
      return(puedo_gastar(propiedad.precio_edificar) && propiedad.num_hoteles < get_hoteles_max && propiedad.num_casas >= @@casas_por_hotel)
    end
      
    def paga_impuesto(cantidad)
      return (super(cantidad/@@factor_especulador))
    end
      
    def to_string
      String::new(cadena = super)
      cadena += "*******ESPECULADOR*******\n"
      cadena += " Fianza = #{@fianza}\n"

      return cadena
    end
  end
end

