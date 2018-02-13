class PrisonerRewardPunishmentController < ApplicationController
  before_action :authenticate!

  def import_index
    render 'import'
  end

  def upload
    @import_result=PrisonerRewardPunishment.upload(params[:file])
    render json: @import_result
  end

  def import
    @import_result=PrisonerRewardPunishment.import(params[:filepath],params[:jail_id])
    render json: @import_result
  end
end
