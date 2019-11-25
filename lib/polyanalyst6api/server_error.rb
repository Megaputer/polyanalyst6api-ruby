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
      body_parsed = JSON.parse(body)
      # TODO: get rid of this condition when new errors format is in the main
      if body_parsed.is_a? Array
        @response_code = '[unknown]'
        @response_title = body_parsed[1]
        @response_message = '[unknown]'
        return
      end
      struct = body_parsed['error']
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
