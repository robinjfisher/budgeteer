class AddPayeeToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :payee, :string
    add_column :transactions, :payee_confirmed, :boolean, default: false
  end
end
