module PolyAnalyst6API
  class Request
    def initialize(base_url, sid, url, method, params)
      @base_url = base_url
      @sid = sid
      @url = url
      @method = method
      @params = params
    end

    def perform!
      begin
        resp = RestClient::Request.execute full_params
      rescue RestClient::InternalServerError => e # Treating 500 code exception as a common response
        error = JSON.parse(e.response.body)[1]
        h = { code: 500, body: { error: error } }
        resp = OpenStruct.new(h)
      end
      return yield(resp) if block_given? # Allowing manual response processing
      JSON.parse(resp.body)
    end

    private

    def full_params
      {
        method: @method,
        url: @base_url + @url,
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
        raise 'Invalid request method!'
      end
    end

    def get_params
      prms = Addressable::URI.new
      prms.query_values = @params
      {
        url: @base_url + @url + '?' + prms.query,
        accept: :json,
        cookies: { sid: @sid }
      }
    end

    def post_params
      {
        headers: {
          cookies: {
            sid: @sid
          },
          content_type: :json,
          accept: :json
        },
        payload: @params.to_json
      }
    end
  end
end
