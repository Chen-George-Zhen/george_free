class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :coin
      t.string :symbol
      t.decimal :price, precision: 40, scale: 20
      t.decimal :amount, precision: 40, scale: 20
      t.string :tr_type

      t.timestamps
    end
  end
end
