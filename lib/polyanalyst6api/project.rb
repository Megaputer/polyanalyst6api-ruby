module PolyAnalyst6API
  class Project
    def initialize(session, uuid)
      @session = session
      @uuid = uuid
    end

    def nodes
      params = {
        method: :get,
        url: '/project/nodes',
        params: { prjUUID: @uuid }
      }
      @session.request(params).perform!['nodes']
    end

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
        raise resp.body[:error] unless resp.code == 202
      end
    end

    def abort!
      params = {
        method: :post,
        url: '/project/global-abort',
        params: {
          prjUUID: @uuid
        }
      }
      @session.request(params).perform! do |resp|
        raise resp.body[:error] unless resp.code == 200
      end
    end

    def save!
      params = {
        method: :post,
        url: '/project/save',
        params: {
          prjUUID: @uuid
        }
      }
      @session.request(params).perform! do |resp|
        raise resp.body[:error] unless resp.code == 202
      end
    end

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
      @session.request(params).perform! do |resp|
        raise resp.body[:error] unless resp.code == 200
        JSON.parse resp.body
      end
    end
  end
end
