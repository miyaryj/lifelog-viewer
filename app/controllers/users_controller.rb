include LifelogClient

class UsersController < ApplicationController

  def me
    @resp = get_profile
  end

end
