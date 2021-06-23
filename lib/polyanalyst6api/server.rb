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

    # Returns server base API url
    # @example
    #   server = Server.new(host: 'localhost, port: 5043, version: '1.0')
    #   server.base_url
    # @return [String] base API url
    def base_url
      @base_url ||= "https://#{@host}:#{@port}/polyanalyst/api/v#{@version}"
    end
  end
end
