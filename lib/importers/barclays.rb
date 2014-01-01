module Importers
  
  require 'csv'
  
  class Barclays
    
    # Importer for statements exported from Barclays Online Banking in CSV format
    #
    # CSV Data Structure
    # Column 1 : Blank
    # Column 2 : Transaction Date
    # Column 3 : Account number and Sort Code
    # Column 4 : Transaction Amount
    # Column 5 : Subcategory (payment/receipt type)
    # Column 6 : Narrative/Description
    #
    # The first row of the CSV file is headings so should be skipped
    # but error checking is built in to avoid importing anything other
    # than transactions.
  
    def self.import(file,account)
    
      file = file
    
      CSV.foreach(file) do |row|
      
        t = Transaction.new
        t.date = row[1]
        t.amount = row[3]
        t.subcategory = row[4]
        t.description = row[5]
        t.account_id = account.id
      
        unless Transaction.find_by_date_and_description(t.date,t.description) || t.date == nil || t.date == "NULL" || t.amount == 0
          t.save
        end
      
      end
    
    end

  end
  
end