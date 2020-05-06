class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.string :symbol, null: false

      t.timestamps null: false
    end
  end
end
