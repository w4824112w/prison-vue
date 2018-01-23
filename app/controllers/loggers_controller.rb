class LoggersController < ApplicationController
  skip_before_action :authorize

  layout 'logs'

  def index
    params[:start] ||= Time.now.beginning_of_month
    params[:end] ||= Time.now.end_of_month
    params[:page] ||= 0
    params[:limit] ||= 10

    total = AppLogger.count_by_sql('SELECT COUNT(*) FROM app_loggers')
    @pages = total % params[:limit].to_i > 0 ? total / params[:limit].to_i + 1 : total / params[:limit].to_i

    @logs = AppLogger.where("created_at BETWEEN '#{params[:start]}' AND '#{params[:end]}'" ).
      limit(params[:limit]).
      offset(params[:limit].to_i * params[:page].to_i)
  end

end
