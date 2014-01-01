class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.date :date
      t.integer :amount_in_pennies
      t.string :type
      t.string :description
      t.integer :account_id
      t.integer :category_id

      t.timestamps
    end
  end
end
