# frozen_string_literal: true

module Spree
  class PaymentMethod
    class StripeCheckout < Spree::PaymentMethod::CreditCard

      def method_type
        'stripe_checkout'
      end

      def supports?(_source)
        true
      end

      def available_for_order?(order)
        true
      end
    end
  end
end
