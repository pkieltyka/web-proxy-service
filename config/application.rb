# Environment configuration
environment :development do
  config[:env] = 'development'
end

environment :production do
  config[:env] = 'production'
end

environment :test do
  config[:env] = 'test'
end

#------------------------------------------------------------------------------

# Settings
config[:settings] = YAML.load_file(WebProxyService.root_path.join('config/settings.yml'))[config[:env]]

# EventMachine configuration
EM.error_handler do |e|
  logger.error "Error raised during asynchronous event loop: #{e.message}"
end

WebProxyService.configure(self)
