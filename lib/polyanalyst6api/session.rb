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
    # @param [Bool] :use_ldap Use ldap or not
    # @param [String] :ldap_server LDAP server address
    # @raise [ServerError] an exception with corresponding server error
    # @return [Session] an instance of Session
    def initialize(server, uname: 'administrator', pwd: '', use_ldap: false, ldap_server: nil)
      @server = server
      url = login_url(uname, pwd, use_ldap, ldap_server)
      params = { method: :post, url: url, verify_ssl: false }
      begin
        resp = RestClient::Request.execute params
      rescue RestClient::InternalServerError => e
        raise ServerError.new(e.response.body)
      end
      @sid = resp.cookies['sid']
      raise 'Login failed!' unless @sid
    end

    # Creates a Request instance (A Request.new alias)
    # @return [Request] Request instance
    def request(url: '', method: :get, params: {}, body: nil)
      Request.new(@server.base_url, @sid, url, method, params, body)
    end

    # Creates an instance of Project (A Project.new alias)
    # @return [Project] Project instance
    def project(uuid)
      Project.new(self, uuid)
    end

    # Returns the server info data (branch, build number, component hashes)
    # @return [json] Server info
    def server_info
      request(url: '/server/info', method: :get).perform!
    end

    private

    def login_url(uname, pwd, use_ldap, ldap_svr)
      ldap = use_ldap ? 1 : 0
      url = "/login?uname=#{uname}&pwd=#{pwd}&useLDAP=#{ldap}&svr=#{ldap_svr}"
      @server.base_url + url
    end
  end
end
