#encoding = utf-8

class RegistrationsController < ApplicationController
  before_action :authenticate!

  def index  
    conditions = { jail_id: session[:jail_id], limit: params[:limit], offset: params[:page].to_i * params[:limit].to_i }

    params.each { |k, v| conditions[k.to_sym] = v if k != 'action' && k != 'controller'}

    @registrations = Registration.list(conditions)

  #  respond_to do |format|
  #    format.html
  #    format.json { render json: @registrations }
  #  end
    render json: @registrations
  end

  def images
    @registration = Registration.find_by_id(params[:id])

    if @registration
      render json: @registration.uuid_images.map(&:image_url)
      return
    end

    render json: [ ]
  end

  def audit
    registration = Registration.find_by_id(params[:id])

    unless registration
      logger.info "registration #{params[:id]} not found"
      render json: { code: 404, msg: 'registration not found' }
      return
    end

    if registration.status == 'PENDING'
      render json: registration.authorization(params[:status], params[:remarks])
      return
    end

    logger.info "multi auti registration ##{params[:id]}" 
    render json: { code: 400, msg: "multi audit registration ##{params[:id]}" }
  end
end

