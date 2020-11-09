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
    # @param settings [Hash or Array] Needed configuration
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   parameters_node = project.parameters_node(75)
    #   parameters = {
    #     node_type: 'TmlLinkTerms\/',
    #     settings: { 'Expression' => 'Test' },
    #     strategies: [8, 9, 10, 11]
    #   }
    #   parameters_node.configure(parameters)
    #
    #   # OR
    #   <...>
    #   parameters = {
    #     node_type: 'SRLRuleSet/SRL Rule',
    #     settings: [
    #       {
    #         'Name' => 'strZstr',
    #         'Rule' => '\'aaa\''
    #       },
    #       {
    #         'Name' => 'strZtext',
    #         'Rule' => '\'bbb\''
    #       },
    #       {
    #         'Name' => 'int',
    #         'Rule' => '1'
    #       },
    #       {
    #         'Name' => 'dateZdate',
    #         'Rule' => '#2012-01-20 01:22#'
    #       }
    #     ]
    #   }
    #   parameters_node.configure(parameters)
    def configure(node_type:, declare_unsync: true, settings: nil, strategies: nil)
      url = '/parameters/configure' if settings.is_a?(Hash)
      url = '/parameters/configure-array' if settings.is_a?(Array)
      raise Error, 'Bad parameters (\'settings\' be a Hash or Array)' unless url

      params = {
        method: :post,
        url: url,
        params: {
          prjUUID: @project.uuid,
          obj: @id
        },
        body: {
          type: node_type,
          declareUnsync: declare_unsync || true,
          settings: settings,
          strategies: strategies || []
        }.to_json.delete('\\')
      }
      @session.request(params).perform!
    end

    # Clears configuration of  a Parameters node (specified nodes or all)
    # @param nodes [Array] The types of node to clear ([] to clear all)
    # @param declare_unsinc [Boolean] true to reset the node status, false to keep
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   parameters_node = project.parameters_node(75)
    #   to_clear = ["SRLRuleSet/SRL Rule", "SRLRuleSet/Filter Rows"]
    #   parameters_node.clear(nodes: to_clear)
    #
    #   # OR
    #   <...>
    #   parameters_node.clear
    #   # all cleared
    def clear(nodes: [], declare_unsync: true)
      params = {
        method: :post,
        url: '/parameters/clear',
        params: {
          prjUUID: @project.uuid,
          obj: @id
        },
        body: {
          nodes: nodes,
          declareUnsync: declare_unsync || true
        }.to_json.delete('\\')
      }
      @session.request(params).perform!
    end
  end
end
