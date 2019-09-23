# frozen_string_literal: true

module PolyAnalyst6API
  # @attr_reader host [String] message
  class ServerError < StandardError
    attr_reader :message
    # @param [String] server message
    def initialize(message)
      @message = message
    end
  end
end
