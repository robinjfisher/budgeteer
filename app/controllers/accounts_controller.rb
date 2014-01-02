class AccountsController < ApplicationController

  def index
    @accounts = Account.all
    if @accounts.empty?
      redirect_to new_account_path
    else
    end
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to accounts_path, notice: "Your account has been created."
    else
      flash.now[:error] = @account.errors.full_messages.empty? ? "Unknown error. Please try again" : @account.errors.full_messages.to_sentence
      render action: "new"
    end
  end
  
  def show
    @account = Account.find(params[:id])
    @categories = Category.all
  end
  
  private
  
  def account_params
    params.require(:account).permit(:name,:description,:current_balance)
  end
  
end
