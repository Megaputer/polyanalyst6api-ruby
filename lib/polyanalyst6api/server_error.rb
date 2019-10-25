# frozen_string_literal: true

module PolyAnalyst6API
  # This class represents server errors
  # response_code [Integer] response code
  # response_title [String] response title
  # response_message [String] response message
  class ServerError < StandardError
    attr_reader :response_code, :tresponse_itle, :response_message
    # @param [String] response json string
    def initialize(body)
      struct = JSON.parse(body)['error']
      @response_code = struct['code']
      @response_title = struct['title']
      @response_message = struct['message']
    end

    # exception message
    def message
      @response_title
    end
  end
end
