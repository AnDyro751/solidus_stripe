# frozen_string_literal: true

module Spree
  class PaymentMethod
    class StripeCheckout < Spree::PaymentMethod::Check
      # 9512061857 - 58 - 60 - 61
      # Comercio al por mayor o por menor de bebidas alcoholicas
      # 82 centavos
      # 1.30 urgentes
      # NOM 070
      # CRM - Provedores
      def partial_name
        'stripe_checkout'
      end

      def method_type
        'stripe_checkout'
      end


      def gateway_class
        ActiveMerchant::Billing::Response.new(true, "", {}, {})
        # Spree::PaymentMethod::CreditCard
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
