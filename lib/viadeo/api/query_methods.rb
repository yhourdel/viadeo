module Viadeo
  module Api

    module QueryMethods

      def profile(access_token)
      	Mash.from_json simple_query(access_token, "/me", {})
      end

			def search_user(access_token, args)
				args = {} if args.nil?
				Mash.from_json simple_query(access_token, "/search/users", args)
			end

      private

        def simple_query(access_token, path, args)
        	url = "#{DEFAULT_OAUTH_OPTIONS[:api_base]}#{path}?access_token=#{access_token}"
        	args.each {|key, value| url += "&#{key}=#{value}"}
			    uri = URI.parse(url)
			    connection = Net::HTTP.new(uri.host, 443)
			 	  connection.use_ssl = true
		 	   	connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
		 	   	resp = connection.request_get(uri.path + '?' + uri.query)
		 	   	if resp.code != '200'
		  	 		raise "web service error"
			    end
			    return resp.body
        end

        def person_path(options)
          path = "/people/"
          if options[:id]
            path += "id=#{options[:id]}"
          elsif options[:url]
            path += "url=#{CGI.escape(options[:url])}"
          else
            path += "~"
          end
        end

    end

  end
end
