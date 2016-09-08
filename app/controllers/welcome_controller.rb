class WelcomeController < ApplicationController
  layout "welcome"
  def index
    @projects  = Project.find(1,2,3)
  end

  def how_it_works
    @projects  = Project.find(1,2,3)
    set_page_title_and_description("用户指南", nil)
  end
end
