module Viadeo
  module Helpers

    module Request

      DEFAULT_HEADERS = {
        'x-li-format' => 'json'
      }

      API_PATH = '/v1'

      protected

        def get(path, options={})
        	ActiveRecord::Base.logger.debug "Viadeo::GET #{API_PATH}#{path}"
        	start = Time.now
          response = access_token.get("#{API_PATH}#{path}", DEFAULT_HEADERS.merge(options))
          ActiveRecord::Base.logger.debug "Done in #{((Time.now-start) * 100).to_i}ms"
          raise_errors(response)
          response.body
        end

        def post(path, body='', options={})
        	ActiveRecord::Base.logger.debug "Viadeo::POST #{API_PATH}#{path}"
        	start = Time.now
          response = access_token.post("#{API_PATH}#{path}", body, DEFAULT_HEADERS.merge(options))
          ActiveRecord::Base.logger.debug "Done in #{((Time.now-start) * 100).to_i}ms"
          raise_errors(response)
          response
        end

        def put(path, body, options={})
        	ActiveRecord::Base.logger.debug "Viadeo::PUT #{API_PATH}#{path}"
        	start = Time.now
          response = access_token.put("#{API_PATH}#{path}", body, DEFAULT_HEADERS.merge(options))
          ActiveRecord::Base.logger.debug "Done in #{((Time.now-start) * 100).to_i}ms"
          raise_errors(response)
          response
        end

        def delete(path, options={})
        	ActiveRecord::Base.logger.debug "Viadeo::DELETE #{API_PATH}#{path}"
        	start = Time.now
          response = access_token.delete("#{API_PATH}#{path}", DEFAULT_HEADERS.merge(options))
          ActiveRecord::Base.logger.debug "Done in #{((Time.now-start) * 100).to_i}ms"
          raise_errors(response)
          response
        end

      private

        def raise_errors(response)
          # Even if the json answer contains the HTTP status code, Viadeo also sets this code
          # in the HTTP answer (thankfully).
          case response.code.to_i
          when 401
            data = Mash.from_json(response.body)
            raise Viadeo::Errors::UnauthorizedError.new(data), "(#{data.status}): #{data.message}"
          when 400, 403
            data = Mash.from_json(response.body)
            raise Viadeo::Errors::GeneralError.new(data), "(#{data.status}): #{data.message}"
          when 404
            raise Viadeo::Errors::NotFoundError, "(#{response.code}): #{response.message}"
          when 500
            raise Viadeo::Errors::InformLinkedInError, "Viadeo had an internal error. Please let them know in the forum. (#{response.code}): #{response.message}"
          when 502..503
            raise Viadeo::Errors::UnavailableError, "(#{response.code}): #{response.message}"
          end
        end

        def to_query(options)
          options.inject([]) do |collection, opt|
            collection << "#{opt[0]}=#{opt[1]}"
            collection
          end * '&'
        end

        def to_uri(path, options)
          uri = URI.parse(path)

          if options && options != {}
            uri.query = to_query(options)
          end
          uri.to_s
        end
    end

  end
end
