# frozen_string_literal: true

module PolyAnalyst6API
  # This class maintains all the operations with a project
  class Project
    # @param session [Session] An instance of Session
    # @param uuid [String] The uuid of a project you want to interact with
    # @return [Project] an instance of Project
    def initialize(session, uuid)
      @session = session
      @uuid = uuid
    end

    # Returns the list of project nodes
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.nodes
    # @return [Array<Hash>] A list with nodes info
    def nodes
      params = {
        method: :get,
        url: '/project/nodes',
        params: { prjUUID: @uuid }
      }
      @session.request(params).perform!['nodes']
    end

    # Executes the passed nodes
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.execute!
    # @param nodes [Array<Hash>] A subset of nodes returned by the method *nodes*
    def execute!(nodes = [])
      params = {
        method: :post,
        url: '/project/execute',
        body: {
          prjUUID: @uuid,
          nodes: nodes
        }.to_json
      }
      @session.request(params).perform!
    end

    # Stops project execution
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.abort!
    def abort!
      params = {
        method: :post,
        url: '/project/global-abort',
        body: {
          prjUUID: @uuid
        }.to_json
      }
      @session.request(params).perform!
    end

    # Saves the project
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.save!
    def save!
      params = {
        method: :post,
        url: '/project/save',
        body: {
          prjUUID: @uuid
        }.to_json
      }
      @session.request(params).perform!
    end

    # Returns the first 1000 rows of a dataset
    # @param type [String] The type of a node
    # @param name [String] The name of a node
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.dataset_preview('DataSource', 'Dataset 01.csv')
    # @return [Array<Hash>] A list of rows info
    def dataset_preview(type, name)
      err = "Invalid node type: #{type} (only 'Dataset' or 'DataSource' are available)"
      raise err unless %w[Dataset DataSource].include? type
      params = {
        method: :get,
        url: '/dataset/preview',
        params: {
          prjUUID: @uuid,
          name: name,
          type: type
        }
      }
      @session.request(params).perform!
    end

    # Returns the execution statistics for a particular project
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.execution_statistics
    # @return [Array<Hash>] A list of rows with per-node statistics
    def execution_statistics
      params = {
        method: :get,
        url: '/project/execution-statistics',
        params: {
          prjUUID: @uuid
        }
      }
      @session.request(params).perform!
    end

    # Initiates prject repair
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.repair!
    def repair!
      params = {
        method: :post,
        url: '/project/repair',
        body: {
          prjUUID: @uuid
        }.to_json
      }
      @session.request(params).perform!
    end

    # Initiates prject removal
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.delete!
    def delete!
      params = {
        method: :post,
        url: '/project/delete',
        body: {
          prjUUID: @uuid
        }.to_json
      }
      @session.request(params).perform!
    end

    # Initiates prject unloading
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.unload!
    def unload!
      params = {
        method: :post,
        url: '/project/unload',
        body: {
          prjUUID: @uuid
        }.to_json
      }
      @session.request(params).perform!
    end

    # Returns a current project tasks list
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.tasks
    # @return [Array<Hash>] A list of tasks info
    def tasks
      params = {
        method: :get,
        url: '/project/tasks',
        params: { prjUUID: @uuid }
      }
      @session.request(params).perform!
    end

    # Configures the Parameters node
    # @param obj_id [Ingeter] The ID of the Parameters node to configure
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
    def parameters_configure(obj_id:, node_type:, declare_unsync: true, settings: {})
      params = {
        method: :post,
        url: '/parameters/configure',
        params: { prjUUID: @uuid, obj: obj_id },
        body: { type: node_type, declareUnsync: declare_unsync, settings: settings }.to_json.delete('\\') }
      @session.request(params).perform!
    end
  end
end
