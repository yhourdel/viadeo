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
        puts "simple_query(#{access_token}, #{path}, #{args})"

        url = "#{DEFAULT_OAUTH_OPTIONS[:api_base]}#{path}?access_token=#{access_token}"
        args.each {|key, value| url += "&#{key}=#{CGI.escape(value.to_s)}"}
        uri = URI.parse(url)
        resp = nil
        connection = Net::HTTP.new(uri.host, 443)
        connection.use_ssl = true
        connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
        resp = connection.request_get(uri.path + '?' + uri.query)

        puts "Viadeo :: resp=#{resp.inspect}"

        return Mash.from_json resp.body
      end

      def simple_post_query(access_token, path, args, post_data = "")
        puts "simple_post_query(#{access_token}, #{path}, #{args})"

        url = "#{DEFAULT_OAUTH_OPTIONS[:api_base]}#{path}?access_token=#{access_token}"
        args.each {|key, value| url += "&#{key}=#{CGI.escape(value.to_s)}"}
        uri = URI.parse(url)
        resp = nil
        connection = Net::HTTP.new(uri.host, 443)
        connection.use_ssl = true
        connection.verify_mode = OpenSSL::SSL::VERIFY_NONE

        if !post_data.respond_to?(:bytesize) && post_data.respond_to?(:map)
          post_data = post_data.map { |k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join('&')
        end

        resp = connection.request_post(uri.path + '?' + uri.query, post_data)

        puts "Viadeo :: resp=#{resp.inspect}"

        return Mash.from_json resp.body
      end

    end
  end
end
