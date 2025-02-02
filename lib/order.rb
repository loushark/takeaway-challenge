require_relative 'text'

class Order

  attr_reader :number, :basket, :total, :history

  def initialize
    @number = 1
    @basket = []
    @total = 0
    @history = []
    @text = Text.new
  end

  def add_to_basket(dish)
    @basket << dish
    total_so_far
  end

# viewing basket with the total cost of basket
  def view_basket
    @print = ["Viewing basket for order number #{@number}:\n"]
    num = 1
    unless num >= @basket.length
      @basket.each do |dish|
        @print << "#{dish[0]} £#{dish[1]}\n"
        num += 1
      end
    end
    @print << "Total cost of order: £#{@total}"
    @print.join(", ").chomp
  end

  # order cannot be completed if the total is not correct
  # completing order sends confirmation text
  def complete_order
    unless total_correct?
      fail "The total of this order is not correct!"
    end

    @text.send_text
    order_history
    reset_order
    "Thank you! Your order was placed and will be delivered before #{(Time.now + 60 * 60).strftime("%I:%M %p")}"
  end

private

  def order_history
    @history << { "Order ##{@number}, completed on #{Time.now}:": @basket.flatten }
  end

  def reset_basket
    @basket = []
  end

  def reset_total
    @total = 0
  end

# reseting after order completed
  def reset_order
    @number += 1
    reset_basket
    reset_total
  end

# calculating and checking totals are correct
  def total_so_far
    @total += @basket[-1][1]
  end

  def total_due
    total = 0
    @basket.each do |price|
      total += price[1]
    end
    total
  end

  def total_correct?
    total_due == @total
  end
end
