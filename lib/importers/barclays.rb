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
    #
    # We can also do some work on the transaction explanations to assist in parsing.
    #
    # The UK transactions in the subcategory PAYMENT, take the form of the payee name
    # to a maximum of 19 characters followed by 4 character groups. Using this information, 
    # we can parse the description to identify the payee.
    #
    # Regex: /(.*)(REF\s\d{3}\s\d{0,10}\s\w{3})/
    #
    # Transactions in the subcategory REPEATPMT are standing orders signified by the
    # STO code in the description. They take the format of the payee name followed
    # by the bank account details.
    #
    # Regex: [\d\s]{6,}STO
    #
    # Transactions in the subcategory DIRECTDEBIT are signified by the DDR code in the
    # description. They take the format of the payee name followed by the DD reference.
    #
    # Regex: \w*\sDDR
    
    def self.import(file,account)
    
      file = file
      running_total = 0
      
      begin
        CSV.foreach(file, encoding: 'windows-1251:utf-8') do |row|
      
          t = Transaction.new
          t.date = row[1]
          t.amount_in_pennies = row[3].gsub(/[.]/,"").to_i
          t.subcategory = row[4]
          t.description = row[5]
          t.account_id = account.id
          
          case t.subcategory
          when "PAYMENT","BCC"
            matchdata = /(.*)(REF\s\d{3}\s\d{0,10}\s\w{3})/.match(t.description)
            if matchdata.nil?
              t.payee = "To be confirmed"
            else
              t.payee = matchdata[1].strip
            end
          when "REPEATPMT"
            t.payee = t.description.gsub(/[\d\s]{6,}STO/,"").strip
          when "DIRECTDEBIT"
            t.payee = t.description.gsub(/\w*\sDDR/,"").strip
          when "REM","FT","CASH","DIRECTDEP"
            t.payee = "Not applicable"
          when "OTH"
            t.payee = "To be confirmed"
          end
      
          unless Transaction.find_by_date_and_description(t.date,t.description) || t.date == nil || t.date == "NULL" || t.amount_in_pennies == 0
            t.save
          end
          
          # This tries to automatically categorise payments based on previously
          # created transactions.
          
          transactions = Transaction.where(payee: t.payee, payee_confirmed: true).reject{|transaction| transaction.id == t.id}
          unless transactions.empty?
            category = transactions.last.category
            t.category = category
            t.save
          end
        
          running_total += t.amount_in_pennies
      
        end
      
        account.current_balance += running_total
        account.save
      end
    
    end

  end
  
end