require_relative 'casilla.rb'

module Civitas
  class Tablero
    attr_reader :num_casilla_carcel
    
    def initialize(casilla_carcel)
      if(casilla_carcel >= 1)
        @num_casilla_carcel=casilla_carcel
      else  
        @num_casilla_carcel=1
      end  
        
      @casillas=[]
      salida = nil
      salida = Casilla.new("Salida")
      @casillas << salida
      @por_salida=0
      @tiene_juez=false      
    end
    
    def correcto
      bool=false
      if(@casillas.length > @num_casilla_carcel) 
        bool=true
      end
      return bool
    end
    
    def correcto1(num_casilla)
      bool=false
      if(correcto) && (num_casilla >= 0 && num_casilla < @casillas.length)
        bool=true
      end
      return bool
    end
    
    def get_por_salida
      antes=@por_salida
      if(@por_salida>0)
        @por_salida-=1
      end
      return antes
    end
    
    def aniade_casilla(casilla)
      if(@casillas.length==@num_casilla_carcel)
        carcel=nil
        carcel=Casilla.new("Carcel")
        @casillas << carcel
      end
      
      @casillas << casilla
      
      if(@casillas.length==@num_casilla_carcel)
        carcel=nil
        carcel=Casilla.new("Carcel")
        @casillas << carcel
      end
    end
    
    def aniade_juez
      if(!@tiene_juez)
        juez=nil
        juez=Casilla_juez.new(@num_casilla_carcel, "Juez")
        @casillas << juez
        @tiene_juez=true
      end
    end
    
    def get_casilla(num_casilla)
      resultado=nil
      if(correcto1(num_casilla))
        resultado=@casillas.at(num_casilla)
      end
      return resultado
    end
    
    def nueva_posicion(actual,tirada)
      nueva_pos=-1
      if(correcto1(actual))
        nueva_pos=actual+tirada
        
        if(nueva_pos>=@casillas.length)
          nueva_pos= nueva_pos % (@casillas.length - 1)
          @por_salida+=1
        end
      end
      return nueva_pos
    end
    
    def calcular_tirada(origen,destino)
      tirada=destino-origen
      if(tirada<0)
        tirada += (@casillas.length)
      end
      return tirada
    end
    
    private :correcto, :correcto1
  end
end
