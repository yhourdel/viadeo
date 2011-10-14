module Viadeo
  module Errors
    class ViadeoError < StandardError
      attr_reader :data
      def initialize(data)
        @data = data
        super
      end
    end

    class RateLimitExceededError < ViadeoError; end
    class UnauthorizedError      < ViadeoError; end
    class GeneralError           < ViadeoError; end

    class UnavailableError       < StandardError; end
    class InformViadeoError    < StandardError; end
    class NotFoundError          < StandardError; end
  end
end
