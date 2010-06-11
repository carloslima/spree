require 'test_helper'

class PerItemCalculatorTest < ActiveSupport::TestCase
  context "Calculator::PerItem" do
    [Coupon, ShippingMethod].each do |calculable| 
      should "be available to #{calculable.to_s}" do
       assert calculable.calculators.include?(Calculator::PerItem)
      end
    end
    should "not be available to TaxRate" do
      assert !TaxRate.calculators.include?(Calculator::PerItem)
    end
  end
  context "#compute (with amount=10)" do
    setup do
      @calculator = Calculator::PerItem.new(:preferred_amount=>10)
      @order = Factory(:order)
    end

    should "be 0 if no products" do
      assert_equal(0, @calculator.compute(@order.line_items))
    end

    context "on orders with a single line_item" do
      should "be 10 when qty=1" do
        @order.line_items << Factory(:line_item, :quantity => 1)
        assert_equal(10, @calculator.compute(@order.line_items))
      end
      should "be 20 when qty=2" do
        @order.line_items << Factory(:line_item, :quantity => 2)
        assert_equal(20, @calculator.compute(@order.line_items))
      end
      should "be 30 when qty=3" do
        @order.line_items << Factory(:line_item, :quantity => 3)
        assert_equal(30, @calculator.compute(@order.line_items))
      end
    end

    context "on orders with multiple line_items" do
      should "be 20 for 2x qty=1" do
        @order.line_items << Factory(:line_item, :quantity => 1)
        @order.line_items << Factory(:line_item, :quantity => 1)
        assert_equal(20, @calculator.compute(@order.line_items))
      end
      should "be 60 for 1x qty=5 + 1x qty=1" do
        @order.line_items << Factory(:line_item, :quantity => 5)
        @order.line_items << Factory(:line_item, :quantity => 1)
        assert_equal(60, @calculator.compute(@order.line_items))
      end
    end
  end
end
