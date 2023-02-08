# frozen_string_literal: true

module PolyAnalyst6API
  # This class stores PolyAnalyst 6.x server data and allows to log in
  # @attr_reader host [String] Server host
  # @attr_reader port [Integer] Server port
  # @attr_reader version [String] API version
  class Server
    attr_reader :host, :port, :version

    # Initializes a Server instance
    # @param [String] :host Server host
    # @param [Integer] :port The prot
    # @param [String] :version API version to use (ex. '1.0', '2.3' etc.)
    # @param [String] :uname The user name to login with
    # @param [String] :pwd The password for specified user name
    # @raise [StandardError] an exception with corresponding login error
    # @return [Session] an instance of Session
    def initialize(host: 'localhost', port: 5043, version: '1.0')
      @host = host
      @port = port
      @version = version # TODO: raise if unsupported version
    end

    # Returns server address
    # @example
    #   server = Server.new(host: 'localhost, port: 5043, version: '1.0')
    #   server.address
    # @return [String] Server address, ex. "https://localhost:5043"
    def address
      @address ||= "#{PolyAnalyst6API.config.scheme}://#{@host}:#{@port}"
    end

    # Returns server base API url
    # @example
    #   server = Server.new(host: 'localhost, port: 5043, version: '1.0')
    #   server.base_url
    # @return [String] base API url
    def api_base
      @api_base ||= "#{address}/polyanalyst/api/v#{@version}"
    end

    # Returns server health status
    # @example
    #   server = Server.new(host: 'localhost, port: 5043, version: '1.0')
    #   server.ok?
    # @return [Boolean] Server health status
    def ok?
      params = {
        method: :get,
        url: "#{address}/polyanalyst/health",
        verify_ssl: PolyAnalyst6API.config.verify_ssl,
        headers: {
          content_type: :json,
          accept: :json
        }
      }

      response = RestClient::Request.execute(params) { |resp, _, _| resp }
      data = JSON.parse(response.body)
      response.code == 200 && data['status'] == 'up'
    end
  end
end
