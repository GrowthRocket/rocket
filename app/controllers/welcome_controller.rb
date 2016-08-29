class WelcomeController < ApplicationController
layout 'welcome'
  def index
    @user = current_user
  end
end
