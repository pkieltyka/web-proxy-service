# require 'ruby-debug'
require 'pathname'
require 'em-synchrony/em-http'

require 'web-proxy-service/version'
require 'web-proxy-service/api_helper'
require 'web-proxy-service/web_proxy'

module WebProxyService
  extend self

  attr_accessor :root_path,
                :lib_path,
                :env,
                :logger,
                :settings

  def configure(env)
    @env      = env
    @logger   = env.logger
    @settings = env.config[:settings]
  end

end

WebProxyService.root_path  = Pathname.new(File.expand_path('../..', __FILE__))
WebProxyService.lib_path   = WebProxyService.root_path.join('lib/web-proxy-service')

# Load controllers
Dir[WebProxyService.lib_path.join('controllers').to_s+'/*.rb'].each {|f| require f }

# Load router
require 'web-proxy-service/router'
