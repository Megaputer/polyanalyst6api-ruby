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
      url = "#{@session.server.base_url}/file/upload"
      http_params = { use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE }
      c = Clientus::Client.new(url, http_params: http_params)
      upload_params = {
        'Cookie' => { 'sid' => @session.sid },
        'Upload-Metadata' => { 'foldername' => Base64.encode64(folder)[0..-2] }
      }
      c.upload(file_path, additional_headers: upload_params)
    end

    def delete_file(file_path)
      @session.request(
        method: :post,
        url: '/file/delete',
        body: {
          path: File.dirname(file_path),
          name: File.basename(file_path)
        }.to_json
      ).perform!
    end

    def download_file(src_path, dst_path)
      dir = File.dirname(src_path)
      dir = '' if dir == '.'
      uid = @session.request(
        method: :post,
        url: '/file/download',
        body: { path: dir, name: File.basename(src_path) }.to_json
      ).perform!['uid']

      r = download_request(uid)
      r.perform! do |resp|
        File.open(dst_path, 'wb') { |f| f.write resp.body }
      end
    end

    private

    def download_request(uid)
      host = @session.server.host
      port = @session.server.port
      download_url = "https://#{host}:#{port}/polyanalyst/download"
      Request.new(@session.sid, download_url, :get, { uid: uid }, nil)
    end
  end
end
