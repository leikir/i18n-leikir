# Mandatory gems

```ruby
gem 'i18n-active_record',
  github: 'pawelnguyen/i18n-active_record',
  branch: 'rails-4',
  require: 'i18n/active_record'
```

# Migration

```ruby
class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.string :locale
      t.string :key
      t.text   :value
      t.text   :interpolations
      t.boolean :is_proc, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
```
