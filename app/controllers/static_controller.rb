class StaticController < ApplicationController
  before_action :authenticate_lifelog

  def top
    @response = session[:oauth_response]
  end

  private

  def authenticate_lifelog
    return if signed_in_to_lifelog?

    store_location
    redirect_to(controller: :sessions, action: :new)
  end

end
