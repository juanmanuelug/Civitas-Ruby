module Civitas
  class Operacion_inmobiliaria
    attr_reader :gestion, :num_propiedad
    def initialize (gest, ip)
      @num_propiedad = gest
      @gestion = ip
    end
  end
end
