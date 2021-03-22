require_relative 'jugador.rb'
module Civitas
  class Titulo_propiedad
    attr_reader :hipotecado,  :nombre,  :num_casas, :num_hoteles, :precio_compra,
      :precio_edificar, :propietario
  
    #Atributos de clase
    @@factor_intereses_hipoteca = 1.1
    
    def initialize(nombre,alquiler_base,factor_revalorizacion,hipoteca_base,
    precio_compra,precio_edificar)
      @alquiler_base = alquiler_base  
      @factor_revalorizacion = factor_revalorizacion
      @hipoteca_base =hipoteca_base
      @nombre = nombre
      @precio_compra = precio_compra
      @precio_edificar = precio_edificar
      @hipotecado = false
      @num_casas = 0
      @num_hoteles = 0
      @propietario = nil     
    end
    
    def actualizar_propietario_por_conversion(jugador)
      @propietario=jugador
    end
    
    def cancelar_hipoteca(jugador)
      result = false
      
      if(@hipotecado)
        if(es_este_el_propietario(jugador))
          result=jugador.paga(get_importe_cancelar_hipoteca())
          @hipotecado=false
        end
      end
      
      return result
    end
    
    def cantidad_casas_hoteles
      return @num_casas +@num_hoteles
    end
    
    def comprar(jugador)
      result=false
      
      if(!tiene_propietario())
        @propietario=jugador
        result=jugador.paga(@precio_compra)
      end
      
      return result
    end
    
    def construir_casa(jugador)
      result=false
      
      if(es_este_el_propietario(jugador))
        result=jugador.paga(@precio_edificar)
        @num_casas+=1
      end
      
      return result
    end
    
    def construir_hotel(jugador)
      result=false
      
      if(es_este_el_propietario(jugador))
        result=jugador.paga(@precio_edificar)
        @num_hoteles+=1
      end
      
      return result
    end
    
    def derruir_casas(n,jugador)
      bool=false
      if(es_este_el_propietario(jugador) && @num_casas>=n)
        @num_casas=@num_casas-n
        bool=true
      end
      return bool
    end
    
    def es_este_el_propietario(jugador)
      return @propietario==jugador
    end
    
    def get_importe_hipoteca
      return @hipoteca_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5))
     
    end
    
    def get_importe_cancelar_hipoteca
      importe_hipoteca=@hipoteca_base*(1+(@num_casas*0.5)+(@num_hoteles*2.5))
      importe_hipoteca=importe_hipoteca*@@factor_intereses_hipoteca
      return importe_hipoteca
    end
    
    def get_precio_venta
      return @precio_compra+@precio_edificar*@factor_revalorizacion
    end
    
    def get_precio_alquiler
      if(!@hipotecado && !@propietario.encarcelado)
        precio_alquiler=@alquiler_base*(1+@num_casas*0.5)+(@num_hoteles*0.5)
      else
        precio_alquiler=0
      end
      return precio_alquiler
    end

    def hipotecar(jugador)
      result = false
      
      if(!@hipotecado && es_este_el_propietario(jugador))
        result=jugador.recibe(get_importe_hipoteca)
        @hipotecado=true
      end
      
      return result
    end
    
    def propietario_encarcelado
      bool=false
      if(@propietario.is_encarcelado)
        bool=true
      end
      return bool
    end
    
    def tiene_propietario
      return @propietario!=nil
    end

    def to_string
      String::new(mensaje="\n**\n")
      mensaje += " " + @nombre + "\n Propietario = "
      if tiene_propietario()
        mensaje+= @propietario.nombre
      else
        mensaje+= "Nadie"
      end
      mensaje += "\n Hipotecado = " + @hipotecado.to_s 
      mensaje += "\n Hipoteca Base: #{@hipoteca_base}"
      #mensaje += "\nFactor Interes de Hipoteca: #{@@factor_intereses_hipoteca}"
      mensaje += "\n Precio de Compra: #{@precio_compra}"
      #mensaje += "\nFactor Revalorizacion: #{@factor_revalorizacion}"
      mensaje += "\n Precio Edificar: #{@precio_edificar}"
      mensaje += "\n#{@num_casas} casas y #{@num_hoteles} hoteles"
      mensaje += "\n**\n\n"

      return mensaje
    end    
    
    def tramitar_alquiler(jugador)
      if(tiene_propietario && !es_este_el_propietario(jugador))
        jugador.paga_alquiler(get_precio_alquiler)
        @propietario.recibe(get_precio_alquiler)
      end
    end
    
    def vender(jugador)
      bool=false
      if(es_este_el_propietario(jugador))
        @propietario=nil
        @num_casas=0
        @num_hoteles=0
        bool=jugador.recibe(get_precio_venta)
      end
      bool
    end
    
    private :es_este_el_propietario,  :get_precio_venta
    
  end
end
