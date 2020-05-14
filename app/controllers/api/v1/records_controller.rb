class Api::V1::RecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    stock = Stock.find(params[:stock_id])
    first_record = stock.records.first
    previous_record = stock.records.last
    current_record = Record.new(record_params)
    current_record.stock_id = stock.id
    build_record(first_record, previous_record, current_record, stock)
    if current_record.save
      render json: current_record
    else
      flash[:notice] = "Your order could not be executed at this time."
      render json: { error: current_record.errors.full_messages }, status: :unprocessable_entity
    end
  end

  protected

  def build_record(first, previous, current, stock)
    if previous == nil && current.format == "buy"
      current.capital = stock.starting_capital - (current.quantity * current.p)
    else
      if current.format == "buy"
        current.capital = previous.capital - (current.quantity * current.p)
        current.quantity = previous.quantity + current.quantity
      elsif current.format == "sell"
        if previous.quantity - current.quantity > 0
          current.return_value = current.quantity * current.p
          current.quantity = previous.quantity - current.quantity
          current.capital = previous.capital + current.return_value
        elsif previous.quantity - current.quantity == 0
          current.return_value = current.quantity * current.p
          current.capital = previous.capital + current.return_value
          current.quantity = previous.quantity - current.quantity
        end
      end
    end
  end

  def record_params
    params.require(:record).permit(:p, :t, :quantity, :format)
  end
end
