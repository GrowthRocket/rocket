class WelcomeController < ApplicationController
  layout "welcome"
  def index
    @projects  = Project.find(8,6,9)
  end
end
