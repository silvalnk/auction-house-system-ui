# frozen_string_literal: true

require "dry/system"
require "dry/auto_inject"

module Auctions
  class Container < Dry::System::Container
    configure do |config|
      config.name = :auctions
    end
  end

  Import = Dry::AutoInject(Container)
end
