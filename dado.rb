require 'singleton'

module Civitas
  class Dado
    include Singleton
    
    attr_reader :ultimo_resultado
    
    @@SalidaCarcel=5
    
    def initialize
      @random=Random.new
      @ultimo_resultado=0
      @debug=false
    end
    
    def tirar
      if(!@debug)
        @ultimo_resultado=@random.rand(1..6)
      else
        @ultimo_resultado=1
      end
      
      @ultimo_resultado
    end
    
    def salgo_de_la_carcel
      salir=false
      if(tirar >= @@SalidaCarcel)
        salir=true
      end
      
      salir
    end
    
    def quien_empieza(n)
      return @random.rand(n)
    end
    
    def set_debug(d)
      @debug=d
      if(@debug)
        Diario.instance.ocurre_evento("Dado: Modo debug activado")
      else
        Diario.instance.ocurre_evento("Dado: Modo debug desactivado")
      end
    end
  end
end