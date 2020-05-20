class TradeLogic

  attr_reader :current_record

  def initialize(stock, current_record)
    @stock = stock
    @first = @stock.records.first
    @previous = @stock.records.last
    @current_record = current_record
  end

  def build_record
    @current_record.stock_id = @stock.id
    if @previous == nil && @current_record.format == "buy"
      @current_record.capital = @stock.starting_capital - (@current_record.quantity * @current_record.p)
    else
      if @current_record.format == "buy"
        @current_record.capital = @previous.capital - (@current_record.quantity * @current_record.p)
        @current_record.quantity = @previous.quantity + @current_record.quantity
      elsif @current_record.format == "sell"
        if @previous.quantity - @current_record.quantity > 0
          @current_record.return_value = @current_record.quantity * @current_record.p
          @current_record.quantity = @previous.quantity - @current_record.quantity
          @current_record.capital = @previous.capital + @current_record.return_value
        elsif @previous.quantity - @current_record.quantity == 0
          @current_record.return_value = @current_record.quantity * @current_record.p
          @current_record.capital = @previous.capital + @current_record.return_value
          @current_record.quantity = @previous.quantity - @current_record.quantity
        end
      end
    end
  end

end
