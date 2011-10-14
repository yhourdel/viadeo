require 'oauth'

module Viadeo

  class << self
  end

  autoload :Api,     "viadeo/api"
  autoload :Client,  "viadeo/client"
  autoload :Mash,    "viadeo/mash"
  autoload :Errors,  "viadeo/errors"
  autoload :Helpers, "viadeo/helpers"
  autoload :Search,  "viadeo/search"
  autoload :Version, "viadeo/version"
end
