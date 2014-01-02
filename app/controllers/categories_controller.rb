class CategoriesController < ApplicationController
  
  def create
    category = params[:category]
    transaction = Transaction.find(params[:transaction_id])
    matchdata = /(.*)\bin\b(.*)/.match(category)
    if root = Category.find_by_name(matchdata[2].strip) # If the root category exists, just create the child
      category = root.children.create(name: matchdata[1].strip)
    else # We need to create the root category and then the child category
      root = Category.create(name: matchdata[2].strip)
      category = root.children.create(name: matchdata[1].strip)
    end
    transaction.category = category
    transaction.save
    respond_to do |format|
      format.json {render json: transaction, include: :category}
    end
  end
  
  def update_transaction
    category = Category.find_by_name(params[:category])
    transaction = Transaction.find(params[:transaction_id])
    transaction.category = category
    transaction.save
    respond_to do |format|
      format.json {render json: transaction, include: :category}
    end
  end
  
end
