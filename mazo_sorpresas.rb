require_relative 'sorpresa'

module Civitas
  class Mazo_sorpresas
    def init
      @sorpresas=[]
      @barajada=false
      @usadas=0
      @cartas_especiales=Array.new
      @ultima_sorpresa=nil
    end
  
  
    def initialize(debug=false)
      @debug=debug
      if(@debug)
        Diario.instance.ocurre_evento("MazoSorpresas: Modo debug activado")
      end
      init
    end

    def al_mazo(s)
      if(!@barajada)
        @sorpresas << s
      end
    end

    def siguiente
      if ((@barajada = false || @usadas == @sorpresas.length) && !@debug)
        @usadas=0
        @sorpresas.shuffle
        @barajada=true
      end
      @usadas+=1
      aux=@sorpresas.at(0)
      @sorpresas.shift
      @sorpresas << aux
      @ultima_sorpresa=aux

      @ultima_sorpresa
    end

    def inhabilitar_carta_especial(sorpresa)
      if @sorpresas.include?(sorpresa)
        @sorpresas.delete(sorpresa)
        @cartas_especiales << sorpresa
        Diario.instance.ocurre_evento("Se inhabilita una carta especial")
      end
    end

    def habilitar_carta_especial(sorpresa)
      if @sorpresas.include?(sorpresa)
        @cartas_especiales.delete(sorpresa)
        @sorpresas << sorpresa
        Diario.instance.ocurre_evento("Se habilita una carta especial")
      end
    end
  end
end
