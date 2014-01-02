class TransactionsController < ApplicationController
  
  def update
    @transaction = Transaction.find(params[:id])
    @transaction.update_attributes(transaction_params)
    respond_to do |format|
      format.json {render json: @transaction}
    end
  end
  
  private
  
  def transaction_params
    params.require(:transaction).permit(:payee,:payee_confirmed,:one_off)
  end
  
end
