module WebProxyService
  module ApiHelper
    
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
      def logger
        WebProxyService.logger
      end
      
      def respond_ok(headers={}, body=nil)
        [200, headers, [body.to_s]]
      end
      
      def respond_bad_request(headers={}, body=nil)
        [400, headers, [body.to_s]]
      end
      
      def respond_bad_gateway(headers={}, body=nil)
        [502, headers, [body.to_s]]
      end
    end
    
  end
end
