# frozen_string_literal: true

module SolidusStripe
  class IntentsController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Order


    def create_checkout_session

    end

  end
end