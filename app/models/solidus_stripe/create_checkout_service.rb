# frozen_string_literal: true

module SolidusStripe
  class CreateCheckoutService
    attr_reader :stripe, :controller

    delegate :request, :current_order, :params, to: :controller

    def initialize(stripe, controller)
      @controller, @stripe = stripe, controller
    end

    def call
      create_checkout
    end

    private

    def create_checkout_session
      begin
        session = Stripe::Checkout::Session.create({
                                                       payment_method_types: ['card'],
                                                       line_items: [{
                                                                        price_data: {
                                                                            currency: 'usd',
                                                                            product_data: {
                                                                                name: 'T-shirt',
                                                                            },
                                                                            unit_amount: 2000,
                                                                        },
                                                                        quantity: 1,
                                                                    }],
                                                       mode: 'payment',
                                                       success_url: "http://localhost:3000/success",
                                                       cancel_url: 'http://localhost:3000/cart',
                                                   })
        return session.id
      rescue => e
        puts "--------------#{e}--errror"
        return nil
      end
    end

    def create_checkout
      checkout_id = create_checkout_session
      Spree::OrderUpdateAttributesDecorator.new(
          current_order,
          payment_checkout_params(checkout_id),
          request_env: request.headers.env
      ).apply
      created_payment = Spree::Payment.find_by(response_code: checkout_id)
      created_payment&.tap { |payment| payment.update!(state: :pending) }
      checkout_id
    end

    def payment_checkout_params(checkout_session)
      {
          payments_attributes: [{
                                    payment_method_id: stripe.id,
                                    amount: current_order.total,
                                    source_attributes: {
                                        gateway_payment_profile_id: checkout_session,
                                        name: address_full_name,
                                        address_attributes: address_attributes
                                    }
                                }]
      }
    end

    def form_data
      params[:form_data]
    end

    def html_payment_source_data
      if form_data.is_a?(String)
        data = Rack::Utils.parse_nested_query(form_data)
        data['payment_source'][stripe.id.to_s]
      else
        {}
      end
    end

    def address_attributes
      html_payment_source_data['address_attributes'] || SolidusStripe::AddressFromParamsService.new(form_data).call.attributes
    end

    def address_full_name
      current_order.bill_address&.full_name || form_data[:recipient]
    end

  end
end
