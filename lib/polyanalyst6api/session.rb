# frozen_string_literal: true

module PolyAnalyst6API
  # This class maintains sessions in PolyAnalyst 6.x
  # @attr_reader sid [String] The SID of current sessoin
  class Session
    attr_reader :sid
    # Log in to a PolyAnslyst Server
    # @param [String] :host The host to login to
    # @param [Integer] :port The prot
    # @param [String] :v API version to use (ex. '1.0', '2.3' etc.)
    # @param [String] :uname The user name to login with
    # @param [String] :pwd The password for specified user name
    # @raise [StandardError] an exception with corresponding login error
    # @return [Session] an instance of Session
    def initialize(server, uname: 'administrator', pwd: '')
      @server = server
      login_url = @server.base_url + "/login?uname=#{uname}&pwd=#{pwd}"
      params = { method: :post, url: login_url, verify_ssl: false }
      begin
        resp = RestClient::Request.execute params
      rescue RestClient::InternalServerError => e
        raise JSON.parse(e.response.body)[1]
      end
      @sid = resp.cookies['sid']
      raise 'Login failed!' unless @sid
    end

    # Creates a Request instance (A Request.new alias)
    # @return [Request] Request instance
    def request(url: '', method: :get, params: {})
      Request.new(@server.base_url, @sid, url, method, params)
    end

    # Creates an instance of Project (A Project.new alias)
    # @return [Project] Project instance
    def project(uuid)
      Project.new(self, uuid)
    end
  end
end
