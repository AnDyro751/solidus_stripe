# frozen_string_literal: true

module SolidusStripe
  class IntentsController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Order


    def complete_order
      current_order.complete
    end

  end
end