class WelcomeController < ApplicationController
layout 'welcome'
  def index
    @projects  = Project.find(1,2,9)
  end
end
