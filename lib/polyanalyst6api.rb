# frozen_string_literal: true

require 'polyanalyst6api/version'

require 'rest-client'
require 'json'
require 'addressable/uri'
require 'cgi'
require 'clientus'
require 'base64'

require 'polyanalyst6api/server'
require 'polyanalyst6api/session'
require 'polyanalyst6api/request'
require 'polyanalyst6api/project'
require 'polyanalyst6api/parameters'
require 'polyanalyst6api/user_folder'
require 'polyanalyst6api/server_error'
require 'polyanalyst6api/error'
require 'polyanalyst6api/config'
require 'polyanalyst6api/report'

# The module for the interaction with PolyAnalyst 6.x API
module PolyAnalyst6API
  def self.server_err_to_s(body)
    body_parsed = JSON.parse(body)
    struct = body_parsed['error']
    code = struct['code']
    title = struct['title']
    message = struct['message']

    msg = "Code #{code}"
    msg += ": #{title}" unless title&.empty?
    msg += ": #{message}" unless message&.empty?
    msg
  end

  class << self
    def config
      @config ||= Config.new
    end
  end
end
