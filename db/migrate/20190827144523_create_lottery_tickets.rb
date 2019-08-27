class CreateLotteryTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :lottery_tickets do |t|
      t.string :type, null: false
      t.string :issue_numer, null: false
      t.string :red_balls, array: true, default: []
      t.string :blue_balls, array: true, default: []

      t.timestamps
    end

    add_index :lottery_tickets, [:type, :issue_numer], unique: true
  end
end
