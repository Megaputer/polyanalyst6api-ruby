module PolyAnalyst6API
  class Session
    attr_reader :sid

    def initialize(domen: 'localhost', port: 5043, v: '1.0', uname: 'administrator', pwd: '')
      @base_url = "https://#{domen}:#{port}/polyanalyst/api/v#{v}"
      login_url = @base_url + "/login?uname=#{uname}&pwd=#{pwd}"
      params = {
        method: :post,
        url: login_url,
        verify_ssl: false
      }
      resp = RestClient::Request.execute params
      @sid = resp.cookies['sid']
      raise 'Login failed!' unless @sid
    end

    def request(url: '', method: :get, params: {})
      Request.new(@base_url, @sid, url, method, params)
    end
  end
end
