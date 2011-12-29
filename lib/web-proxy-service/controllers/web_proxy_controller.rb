module WebProxyService
  class WebProxyController < Goliath::API
    include ApiHelper
    
    def response(env)      
      WebProxy.new(env, params).proxy!
    end
    
  end
end
