module Viadeo
  module Api

    module QueryMethods

      def profile(access_token)
      	simple_query(access_token, "/me", {})
      end

			def search_user(access_token, args)
				args = {} if args.nil?
				simple_query(access_token, "/search/users", args)
			end


     	def simple_query(access_token, path, args)
        url = "#{DEFAULT_OAUTH_OPTIONS[:api_base]}#{path}?access_token=#{access_token}"
        args.each {|key, value| url += "&#{key}=#{value}"}
			  uri = URI.parse(url)
			  (1..3).each do
					connection = Net::HTTP.new(uri.host, 443)
				 	connection.use_ssl = true
			 	  connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
			 	  resp = connection.request_get(uri.path + '?' + uri.query)
					return Mash.from_json resp.body if resp.code == '200'
				end
				return nil
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
