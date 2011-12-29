module WebProxyService
  class Router < Goliath::API
    use ::Rack::ContentLength
    use Goliath::Rack::Params
    use Goliath::Rack::Heartbeat, { :path => '/health_check', :response => [200, {}, []] }
    
    map '' do
      run Proc.new {|env| [200, {}, ['hi']] }
    end
    
    get '/favicon.ico' do
      run Proc.new {|env| [200, {}, ['']] }
    end
    
    map WebProxy::ENDPOINT do
      run WebProxyController.new
    end
    
    not_found do
      run PageNotFoundController.new
    end
  end
end
