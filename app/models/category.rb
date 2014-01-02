class Category < ActiveRecord::Base
  
  has_ancestry
  
  has_many :transactions
  
  def anticipated_spend_based_on_previous_pay_period(account)
    pay_date_this_month = Date.new(Date.today.year,Date.today.month,Rails.configuration.pay_period_starts)
    ppp_start = (Date.today - 1.month)
    ppp_finish = (pay_date_this_month - (1.month + 1.day))
    ids = self.root? ? self.child_ids : self.id
    ppp_transactions = account.transactions.where(category_id: ids, date: (ppp_start..ppp_finish), one_off: false)
    ppp_transactions.map(&:amount_in_pennies).inject(0,&:+)
  end
  
  def spend_in_previous_pay_period(account)
    pay_date_this_month = Date.new(Date.today.year,Date.today.month,Rails.configuration.pay_period_starts)
    if pay_date_this_month > Date.today
      ppp_start = pay_date_this_month - 2.months
      ppp_finish = pay_date_this_month - 1.month - 1.day
    else
      ppp_start = pay_date_this_month - 1.month
      ppp_finish = pay_date_this_month - 1.day
    end
    ids = self.root? ? self.child_ids : self.id
    ppp_transactions = account.transactions.where(category_id: ids, date: (ppp_start..ppp_finish))
    ppp_transactions.map(&:amount_in_pennies).inject(0,&:+)
  end
  
  def spend_in_current_pay_period(account)
    pay_date_this_month = Date.new(Date.today.year,Date.today.month,Rails.configuration.pay_period_starts)
    if pay_date_this_month > Date.today
      cpp_start = pay_date_this_month - 1.month
      cpp_finish = pay_date_this_month - 1.day
    else
      cpp_start = pay_date_this_month
      cpp_finish = pay_date_this_month + 1.month - 1.day
    end
    ids = self.root? ? self.child_ids : self.id
    cpp_transactions = account.transactions.where(category_id: ids, date: (cpp_start..cpp_finish))
    cpp_transactions.map(&:amount_in_pennies).inject(0,&:+)
  end
  
  def committed_spend_for_pay_period(account)
    pay_date_this_month = Date.new(Date.today.year,Date.today.month,Rails.configuration.pay_period_starts)
    period_start = (Date.today - 1.month)
    period_finish = (pay_date_this_month - 1.month - 1.day)
    ids = self.root? ? self.child_ids : self.id
    cs_transactions = account.transactions.where(category_id: ids, date: (period_start..period_finish), subcategory: ["DIRECTDEBIT","REPEATPMT","DIRECTDEP"])
    cs_transactions.map(&:amount_in_pennies).inject(0,&:+)
  end
  
end
