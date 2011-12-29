module WebProxyService
  class WebProxy
    ENDPOINT        = '/webp'
    URL_PARAM_NAME  = 'url'
    
    attr_accessor :env, :params, :referred, :url
    
    def initialize(env, params, referred=false)
      self.env      = env
      self.params   = params
      self.referred = referred
    end
    
    def proxy!
      # Pass the headers from original source
      req_headers = {}
      req_headers['Accept']         = env['HTTP_ACCEPT']
      req_headers['Accept-Charset'] = env['HTTP_ACCEPT_LANGUAGE']
      req_headers['Cookie']         = env['HTTP_COOKIE']
      req_headers['User-Agent']     = env['HTTP_USER_AGENT']
      # req_headers['X-Remote-Addr']  = env['REMOTE_ADDR'] # ... ? for geo, etc.
      # req_headers['Referer']        = env['?']
      # req_headers['Via']            = '?' # We let the server know we're proxying... correct/useful form?

      # Let's get the content
      http = EM::HttpRequest.new(url).get({ :head => req_headers })
      response_code = http.response_header.status
      # rescue......... whitelist..... ?
      # .. add protection.. sanitization ... etc...........
            
      # Redirected?
      if response_code >= 300 && response_code < 400 && http.response_header.has_key?('LOCATION')
        return [301, {'Location' => location(http.response_header['LOCATION']) }, nil]
      end
      
      # We good?
      if http.response_header.status != 200
        return [http.response_header.status, {}, http.response.to_s]
      end
    
      # JS injection... ?
      # inject_code(content)
      
      # TODO ... cache the result....? .. uh ... prob a good idea
      
      # Done
      [200, {}, http.response.to_s]
    end
    
    def url
      @url ||= begin
        if referred
          # This must be coming from a secondary proxy request, get the source
          # url from the referer param
          query = Addressable::URI.parse(env['HTTP_REFERER']).query_values

          if !query.is_a?(Hash) || !query.has_key?('url')
            raise "Cannot determine url from proxy request... what??"
          end
          
          Addressable::URI.join(query['url'], env['REQUEST_URI']).to_s
        elsif params.has_key?('url')
          params['url']
        else
          # This should never happen.... what if it does?
          # TODO: log.. and better exception handling...
          raise "Cannot determine url from proxy request... what??"
        end
      end
    end
    
    def location(path)
      "?#{URL_PARAM_NAME}=#{path}"
    end
    
  end
end
