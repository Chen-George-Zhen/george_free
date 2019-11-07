class CreateCoins < ActiveRecord::Migration[6.0]
  def change
    create_table :coins do |t|
      t.string :currency
      t.decimal :entent, precision: 40, scale: 20
      t.decimal :basic_price, precision: 40, scale: 20
      t.decimal :investment_amount, precision: 40, scale: 20

      t.timestamps
    end
    add_index :coins, :currency, unique: true
  end
end
