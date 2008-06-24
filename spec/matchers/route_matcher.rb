module Spec
  module Rails
    module Matchers
      
      class Route
        def initialize(url)
          uri = URI.parse(url)
          @request = ActionController::TestRequest.new
          @request.env["HTTPS"] = uri.scheme == "https" ? "on" : nil
          @request.host = uri.host
          @request.request_uri = uri.path.empty? ? "/" : uri.path
        end
        
        def matches?(options)
          @options = options
          begin
            ActionController::Routing::Routes.recognize(@request) && @options == @request.symbolized_path_parameters
          rescue # recognize raises an error
            false
          end
        end
        
        def failure_message
          "expected #{@request.request_uri} to be recognized as #{@options.inspect}"
        end
        
        def negative_failure_message
          "expected #{@request.request_uri} to not be recognized as #{@options.inspect}"
        end
      end
      
      def recognize_request(url)
        Route.new(url)
      end
      
    end
  end
end