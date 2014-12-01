module CheckoutControllerCODExtension
  def apply_payment_method_charges
    return unless @order && payment_method_ids = payment_method_ids_from_params.presence
    if chargable_p_ms = Spree::PaymentMethod.where(id: payment_method_ids.map(&:to_i)).where.not(charge: [nil, 0]).presence
      chargable_p_ms.each do |payment_method|
        next if @order.adjustments.any?{ |o_a| o_a.source == payment_method }
        @order.adjustments.create(
          amount: payment_method.charge,
          source: payment_method,
          order: @order,
          adjustable: @order,
          label: payment_method.name
        )
      end
    else
      @order.adjustments.select{ |o_a| o_a.source.is_a?(Spree::PaymentMethod) }.each(&:destroy)
    end
    @order.updater.update_totals
    @order.updater.persist_totals
  end

  private

  def payment_method_ids_from_params
    params.fetch(:order, {}).fetch(:payments_attributes, []).map{ |p_a| p_a.fetch(:payment_method_id, nil)}
  end

end

Spree::CheckoutController.class_eval do
  before_action :apply_payment_method_charges, only: [:update]
  prepend CheckoutControllerCODExtension
end
  
