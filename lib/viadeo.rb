require 'oauth'

module Viadeo

	DEFAULT_OAUTH_OPTIONS =
		{
   		:authorize_url => 'https://secure.viadeo.com/oauth-provider/authorize2',
     	:token_url => 'https://secure.viadeo.com/oauth-provider/access_token2',
     	:api_base => 'https://api.viadeo.com'
   	}

  class << self
  
  	def configure
  		yield self
  		true
    end
  end

  autoload :Api,     "viadeo/api"
  autoload :Client,  "viadeo/client"
  autoload :Mash,    "viadeo/mash"
  autoload :Errors,  "viadeo/errors"
  autoload :Helpers, "viadeo/helpers"
  autoload :Search,  "viadeo/search"
  autoload :Version, "viadeo/version"
end
