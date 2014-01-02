class Transaction < ActiveRecord::Base
  
  belongs_to :account
  belongs_to :category
  
  def root_category
    self.category.root
  end
  
end
