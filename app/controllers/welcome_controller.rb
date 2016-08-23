class WelcomeController < ApplicationController
  # def index
  #   flash[:warning] = "Flash test."
  # end
layout "welcome"
  def index
  @project = Project.last
  @posts = @project.posts
  end
end
