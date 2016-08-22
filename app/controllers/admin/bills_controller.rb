class Admin::BillsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_is_admin

  def index

  end
end
