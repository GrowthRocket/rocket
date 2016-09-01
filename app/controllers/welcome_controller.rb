class WelcomeController < ApplicationController
  layout "welcome"
  def index
    @projects  = Project.find(8,6,10)
  end

  def how_it_works
    @projects  = Project.find(8,6,10)
  end
end
