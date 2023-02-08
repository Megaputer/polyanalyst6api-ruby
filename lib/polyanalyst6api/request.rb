# frozen_string_literal: true

module PolyAnalyst6API
  # This class allows to construct requests, execute them and process their
  # responses
  class Request
    # @param [String] base_url Base part of url (host, port, API version)
    # @param [String] sid A session SID
    # @param [String] url Request specific url part of an url
    # @param [String] method Http method of a request
    # @param [String] params Parameters
    # @return [Request] an instance of Request
    def initialize(sid, url, method, params, body)
      @sid = sid
      @url = url
      @method = method
      @params = params
      @body = body
    end

    # Executes the request (and allows response manual processing)
    # @raise [StandardError] An exception with corresponding error message
    # @yield [response] Manual reponse processing
    # @yieldparam response [RestClient::Response] A response to process
    # @yieldreturn [custom] The result of a block
    # @return [Hash] The parsed response body (default)
    # @return [custom] The result of passed block (if passed)
    def perform!
      begin
        resp = RestClient::Request.execute full_params
      rescue RestClient::ServiceUnavailable => e
        raise e unless PolyAnalyst6API.config.repeat_on_pabusy
        retry
      rescue RestClient::InternalServerError => e
        raise ServerError, PolyAnalyst6API.server_err_to_s(e.response.body)
      end
      return yield(resp) if block_given? # Allowing manual response processing
      return 202 if resp.code == 202
      data = resp.body
      begin
        data.empty? ? nil : JSON.parse(data)
      rescue JSON::ParserError
        data
      end
    end


    private

    def full_params
      {
        method: @method,
        url: @url,
        verify_ssl: false
      }.merge(method_patams)
    end

    def method_patams
      case @method
      when :get
        get_params
      when :post
        post_params
      else
        raise Error, 'Invalid request method!'
      end
    end

    def get_params
      prms = Addressable::URI.new
      prms.query_values = @params
      {
        url: "#{@url}?#{prms.query}",
        accept: :json,
        cookies: { sid: @sid }
      }
    end

    def post_params
      prms = Addressable::URI.new
      prms.query_values = @params
      {
        url: "#{@url}?#{prms.query}",
        headers: {
          cookies: { sid: @sid },
          content_type: :json,
          accept: :json
        },
        payload: @body
      }
    end
  end
end
