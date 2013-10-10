class Translation < ActiveRecord::Base

  after_save :reload

  def reload
    I18n.backend.reload!
  end

end
