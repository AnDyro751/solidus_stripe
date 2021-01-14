# frozen_string_literal: true

module Spree
  class PaymentMethod
    class Gateway::StripeAchGateway < Spree::Gateway::Check

      def method_type
        'stripe_checkout'
      end

      def payment_source_class
        Check
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
