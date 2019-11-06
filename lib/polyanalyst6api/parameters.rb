# frozen_string_literal: true

module PolyAnalyst6API
  # This class maintains all the operations with Parameters node
  class Parameters
    # @param session [Session] An instance of Session
    # @return [Parameters] an instance of Parameters
    def initialize(session)
      @session = session
    end

    # Returns the list of nodes that available for configuration via Parameters node
    # @example
    #   parameters = Parameters.new Session.new
    #   parameters.available_nodes
    # @return [Array<Hash>] A list of parameters for available nodes
    def available_nodes
      params = {
        method: :get,
        url: '/parameters/nodes'
      }
      @session.request(params).perform!
    end
  end
end
