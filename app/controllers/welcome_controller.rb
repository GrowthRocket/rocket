class WelcomeController < ApplicationController
  layout "welcome"
  def index
    @projects  = Project.find(1,2,3)
  end

  def how_it_works

  end
end
