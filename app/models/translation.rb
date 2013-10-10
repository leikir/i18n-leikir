class Translation < ActiveRecord::Base

  after_save :reload

  def reload
    I18n.backend.reload!
    ActiveAdmin.reload! if defined?(::ActiveAdmin)
  end

end
