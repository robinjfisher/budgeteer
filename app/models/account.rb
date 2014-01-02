class Account < ActiveRecord::Base
  
  has_many :transactions
  
  def expected_balance
    balance = 0
    Category.roots.each do |cat|
      balance += cat.anticipated_spend_based_on_previous_pay_period(self)
    end
    self.current_balance += balance
  end
  
  
  
end
