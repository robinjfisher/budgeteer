class FileUploadsController < ApplicationController
  
  def new
    @account = Account.find(params[:id])
  end

  def create
    path = params[:file].tempfile.path
    account = Account.find(params[:id])
    @transactions = Importers::Barclays.import(path,account)
    redirect_to show_account_path(account)
  end
  
end
