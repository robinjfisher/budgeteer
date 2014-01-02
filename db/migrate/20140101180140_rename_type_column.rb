class RenameTypeColumn < ActiveRecord::Migration
  
  def self.up
    rename_column :transactions, :type, :subcategory
  end

  def self.down
    rename_column :transactions, :subcategory, :type
  end
  
end
