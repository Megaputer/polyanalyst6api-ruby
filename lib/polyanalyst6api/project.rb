# frozen_string_literal: true

module PolyAnalyst6API
  # This class maintains all the operations with a project
  class Project
    attr_reader :uuid

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
      @session.request(**params).perform!['nodes']
    end

    # Executes the passed nodes
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.execute!
    # @param nodes [Array<Hash>] A subset of nodes returned by the method *nodes*
    # @return [Int] Execution wave ID
    def execute!(nodes = [])
      params = {
        method: :post,
        url: '/project/execute',
        body: {
          prjUUID: @uuid,
          nodes: nodes
        }.to_json
      }
      @session.request(params).perform! do |resp|
        params = CGI.parse(resp.headers[:location])
        params['executionWave'].first
      end
    end

    # Checks if a project is running
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.running?
    # @param exec_wave [Int] Execution wave ID (leave empty if want to check all)
    # @return [Boolean] true if project is running
    def running?(exec_wave = nil)
      params = {
        method: :get,
        url: '/project/is-running',
        params: {
          prjUUID: @uuid,
          executionWave: exec_wave || -1
        }
      }
      @session.request(params).perform!['result'] == 1
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
        }
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
        }
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
      raise Error, err unless %w[Dataset DataSource].include? type
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
        }
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

    def parameters_node(node_id)
      Parameters.new(@session, self, node_id)
    end
  end
end
