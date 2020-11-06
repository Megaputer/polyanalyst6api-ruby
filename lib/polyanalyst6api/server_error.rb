# frozen_string_literal: true

module PolyAnalyst6API
  # This class represents server errors
  # response_code [Integer] response code
  # response_title [String] response title
  # response_message [String] response message
  class ServerError < StandardError
    attr_reader :code, :title, :message
    # @param [String] response json string
    def initialize(body)
      body_parsed = JSON.parse(body)
      struct = body_parsed['error']
      @code = struct['code']
      @title = struct['title']
      @message = struct['message']
    end

    def full_message
      msg = "Code #{@code}"
      msg += ": #{@title}" unless @title&.empty?
      msg + ": #{@message}" unless @message&.empty?
    end
  end
end
