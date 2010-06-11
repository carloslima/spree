class Calculator::PerItem < Calculator
  preference :amount, :decimal, :default => 0

  def self.description
    I18n.t("flat_rate_per_item")
  end

  def self.register
    super
    Coupon.register_calculator(self)
    ShippingMethod.register_calculator(self)
    ShippingRate.register_calculator(self)
  end

  def compute(object=nil)
    items_count = object.inject(0) {|count, line_item| count + line_item.quantity }
    self.preferred_amount * items_count
  end
end
