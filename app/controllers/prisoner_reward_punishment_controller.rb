class PrisonerRewardPunishmentController < ApplicationController

  def import_index
    render 'import'
  end

  def upload
    @import_result=PrisonerRewardPunishment.upload(params[:file])
    render json: @import_result
  end

  def import
    @import_result=PrisonerRewardPunishment.import(params[:filepath],session[:jail_id])
    render json: @import_result
  end
end
