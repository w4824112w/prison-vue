class ShortMessagesController < ApplicationController
  before_action :authenticate!

  def index
    @sms = ShortMessage.all
  end
end
