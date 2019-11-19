# frozen_string_literal: true

module PolyAnalyst6API
  # This class maintains all the operations with user folder on the server
  class UserFolder
    def initialize(session)
      @session = session
    end

    def create_folder(path, folder_name)
      @session.request(
        method: :post,
        url: '/folder/create',
        body: {
          path: path,
          name: folder_name
        }.to_json
      ).perform!
    end

    def delete_folder(path, folder_name)
      @session.request(
        method: :post,
        url: '/folder/delete',
        body: {
          path: path,
          name: folder_name
        }.to_json
      ).perform!
    end

    # def upload_file(path, file_name); end
  end
end
