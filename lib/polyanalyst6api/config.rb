# frozen_string_literal: true

module PolyAnalyst6API
  # This class contains gem configuration
  class Config
    attr_accessor :repeat_on_pabusy, :scheme, :verify_ssl

    def initialize
      @repeat_on_pabusy = true
      @scheme = 'https'
      @verify_ssl = false
    end
  end
end
