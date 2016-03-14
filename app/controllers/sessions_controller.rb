include LifelogClient

class SessionsController < ApplicationController

  def new
    redirect_to(authorize_url)
  end

  def callback
    response = get_access_token(params[:code])
    store_oauth_response(response)

    redirect_back
  end

  def destroy
    # TODO
    redirect_to instagram_sign_in_path
  end
end
