class AddOneOffToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :one_off, :boolean, default: false
  end
end
