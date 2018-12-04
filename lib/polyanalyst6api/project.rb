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

    # Returns a list of project nodes
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
    # @param nodes [Array<Hash>] A subset of nodes returned by the method *nodes*
    # @return [bool] true - execution started; false - something went wrong
    def execute!(nodes = [])
      params = {
        method: :post,
        url: '/project/execute',
        params: {
          prjUUID: @uuid,
          nodes: nodes
        }
      }
      @session.request(params).perform! do |resp|
        return false unless resp.code == 202
      end
      true
    end

    # Stops project execution
    # @return [bool] true - execution stopped; false - something went wrong
    def abort!
      params = {
        method: :post,
        url: '/project/global-abort',
        params: {
          prjUUID: @uuid
        }
      }
      @session.request(params).perform! do |resp|
        return false unless resp.code == 200
      end
      true
    end

    # Saves the project
    # @return [bool] true - saved successfully; false - something went wrong
    def save!
      params = {
        method: :post,
        url: '/project/save',
        params: {
          prjUUID: @uuid
        }
      }
      @session.request(params).perform! do |resp|
        return false unless resp.code == 202
      end
      true
    end

    # Returns the first 1000 rows of a dataset
    # @param type [String] The type of a node
    # @param name [String] The name of a node
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.dataset_preview('DataSource', 'Dataset 01.csv')
    # @return [Array<Hash>] A list of rows info
    def dataset_preview(type, name)
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
        params: {
          prjUUID: @uuid
        }
      }
      @session.request(params).perform! do |resp|
      end
    end

    # Initiates prject removal
    # @example
    #   project = Project.new(Session.new, '4c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   project.delete!
    def delete!
      params = {
        method: :post,
        url: '/project/delete',
        params: {
          prjUUID: @uuid
        }
      }
      @session.request(params).perform! do |resp|
      end
    end
  end
end
