require_relative 'vista_textual.rb'
require_relative 'controlador.rb'
require_relative 'civitas_juego.rb'
require_relative 'dado.rb'

module Civitas
  class Test_P3
    def self.main
      vista = Vista_textual.new
      
      nombres = []
      nombres << "Juanma"
      nombres << "Pepe"
      nombres << "Pablito"
      nombres << "Carlos"
      
      juego = Civitas_juego.new(nombres)
      
      Dado.instance.set_debug(true)
      
      controlador = Controlador.new(juego, vista)
      
      controlador.juega
    end
  end
end

Civitas::Test_P3.main