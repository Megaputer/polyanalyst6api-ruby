# frozen_string_literal: true

module PolyAnalyst6API
  # This class maintains all the operations with Parameters node
  class Parameters
    NODE_TYPE = 'Parameters'
    # @param session [Session] An instance of Session
    # @param project [Project] An instance of Session
    # @param node_id [Integer] ID of a node
    # @return [Parameters] an instance of Parameters
    def initialize(session, project, node_id)
      @session = session
      @project = project
      @id = node_id
      node_data = @project.nodes.detect { |n| n['id'] == @id }
      raise Error, "Node with id #{@id} not found" unless node_data
      return if node_data['type'] == NODE_TYPE
      raise Error, 'This is not a Parameters node'
    end

    # Configures a Parameters node
    # @param node_type [String] The type of node to configure Parameters for
    # @param declare_unsinc [Boolean] true to reset the node status, false to keep
    # @param settings [Hash] Needed configuration
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   settings = {
    #     "Group name": "test",
    #     "Terms name": "test1",
    #     "Expression": "test2"
    #   }
    #   project.parameters_configure(12, "TmlLinkTerms/", settings)
    def configure(node_type:, declare_unsync: true, settings: {}, strategies: nil)
      params = {
        method: :post,
        url: '/parameters/configure',
        params: {
          prjUUID: @project.uuid,
          obj: @id
        },
        body: {
          type: node_type,
          declareUnsync: declare_unsync,
          settings: settings,
          strategies: strategies
        }.to_json.delete('\\')
      }
      @session.request(params).perform!
    end
  end
end
