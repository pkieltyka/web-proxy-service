module WebProxyService
  class PageNotFoundController < Goliath::API
    include ApiHelper
    
    def response(env)
      # First we check if the page not found route is from a WebProxy request.
      # The way we see it is if a request has made it here, to our server,
      # and determined as not found, and in the referer string has our
      # endpoint.. it is proxied request
      is_proxied = !(env['HTTP_REFERER'] =~ /#{WebProxy::ENDPOINT}/i).nil?
      
      # NOTE: .. if there is a route that matches something in our api (router.rb)..
      # it will explode! therefore... better to have nginx+rewrite in front...
      
      if is_proxied
        # Pass to our WebProxy ...
        WebProxy.new(env, params, true).proxy!
      else
        [404, {}, ['Page not found.']]
      end
    end
    
  end
end
