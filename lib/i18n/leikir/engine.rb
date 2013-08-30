module I18n
  module Leikir
    class Engine < Rails::Engine
      config.after_initialize do
        require 'i18n/backend/active_record'

        if defined?(I18n::Backend::ActiveRecord)
          require "i18n/config/initializer"

        else
          raise "::I18n::Backend::ActiveRecord not found, are you sure you included the i18n-activerecord gem ?"
        end
      end
    end
  end
end
