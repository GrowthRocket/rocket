class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def admin?
    true
  end
end
