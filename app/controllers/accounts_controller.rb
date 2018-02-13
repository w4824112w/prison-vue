class AccountsController < ApplicationController
#  layout 'auditor'
before_action :authenticate!

  def index
    params[:limit] ||= 10
    params[:page] ||= 0
    render json: Account.list(params[:jail_id], params[:limit].to_i, params[:limit].to_i * params[:page].to_i)
  #  respond_to do |format|
  #    format.html
  #    format.json { 
  #      render json: Account.list(session[:jail_id], params[:limit].to_i, params[:limit].to_i * params[:page].to_i) }
  #  end
  end

  def show
    account = Account.find_by(id: params[:id])
    if account
      render json: { code: 200, status: 'SUCCESS', details: account.account_details }
      return
    end

    render json: { code: 404, status: 'ERROR', message: 'Can not find account details' }
  end

end	