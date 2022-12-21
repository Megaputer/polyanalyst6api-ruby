# frozen_string_literal: true

module PolyAnalyst6API
  # This class maintains all the operations with a report
  class Report
    attr_reader :uuid

    # @param session [Session] An instance of Session
    # @param uuid [String] The uuid of a report you want to interact with
    # @return [Report] an instance of Report
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

    # Returns list of report components
    # @example
    #   report = Report.new(Session.new, '5c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   report.components
    # @return [Array<Hash>] List of components data
    def components
      params = {
        method: :get,
        url: '/report/components',
        params: {
          reportUUID: @uuid
        }
      }
      @session.request(params).perform!
    end

    # Returns list of report publications
    # @example
    #   report = Report.new(Session.new, '5c44659c-4edb-4f3e-8342-b10451b96f3f')
    #   report.publications
    # @return [Array<Hash>] List of publication data
    def publications
      params = {
        method: :get,
        url: '/report/publications',
        params: {
          reportUUID: @uuid
        }
      }
      @session.request(params).perform!
    end
  end
end
