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

    def upload_file(file_path, folder = '/')
      url = @session.server.base_url + '/file/upload'
      http_params = { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
      c = Clientus::Client.new(url, http_params: http_params)
      upload_params = {
        'Cookie' => { 'sid' => @session.sid },
        'Upload-Metadata' => { 'foldername' => Base64.encode64(folder)[0..-2] }
      }
      c.upload(file_path, additional_headers: upload_params)
    end
  end
end
