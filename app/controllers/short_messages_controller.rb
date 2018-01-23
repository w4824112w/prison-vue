class ShortMessagesController < ApplicationController
  def index
    @sms = ShortMessage.all
  end
end
