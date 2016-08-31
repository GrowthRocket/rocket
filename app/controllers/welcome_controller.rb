class WelcomeController < ApplicationController
  layout "welcome"
  def index
    @projects  = Project.find(1,2,3)
  end

  def how_it_works
    @projects  = Project.find(8,6,9)
  end
end
