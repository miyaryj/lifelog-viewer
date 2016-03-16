require 'httpclient'
require 'open-uri'

module LifelogClient
  CLIENT_ID = ENV['LIFELOG_CLIENT_ID']
  CLIENT_SECRET = ENV['LIFELOG_CLIENT_SECRET']

  def signed_in_to_lifelog?
    return false unless session[:oauth_response]
    true
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back(default: root_path)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def authorize_url
    "https://platform.lifelog.sonymobile.com/oauth/2/authorize?client_id=#{CLIENT_ID}&scope=lifelog.profile.read+lifelog.activities.read+lifelog.locations.read"
  end

  def get_access_token(code)
    resp = HTTPClient.new.post(
      URI.parse('https://platform.lifelog.sonymobile.com/oauth/2/token'),
      {
        'client_id' => CLIENT_ID,
        'client_secret' => CLIENT_SECRET,
        'grant_type' => 'authorization_code',
        'code' => code
      }
    )
    JSON.parse(resp.body)
  end

  def store_oauth_response(response)
    session[:oauth_response] = response
  end

  def clear_oauth_response
    session.delete(:oauth_response)
  end

  def oauth_user
    response = session[:oauth_response]
    Hashie::Mash.new(response['user']) if response
  end

  def get_profile
    resp = open(
      'https://platform.lifelog.sonymobile.com/v1/users/me',
      {
        'Authorization' => "Bearer #{session[:oauth_response]['access_token']}"
      }
    )
    ActiveSupport::JSON.decode resp.read
  end
end
