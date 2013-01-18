require 'cgi'

module Viadeo

  class Client

    include Helpers::Request
    include Helpers::Authorization
    include Api::QueryMethods
    include Search

    attr_reader :client_api_id, :client_api_secret, :consumer_options, :token

    def initialize(client_api_id, client_api_secret, options={})
      @client_api_id   = client_api_id
      @client_api_secret   = client_api_secret
      @consumer_options = options
    end

  end

end
