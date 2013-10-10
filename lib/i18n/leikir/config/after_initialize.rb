module I18n
  module Backend
    class Chain
      def initialized?
        backends.each do |backend|
          return false if !backend.initialized?
        end
        return true
      end

    protected

      def translations
        trans = {}
        backends.reverse.each do |backend| # reverse so that the top most will be merged-in
          backend.instance_eval do
            trans.deep_merge!(translations)
          end
        end
        return trans
      end

      def init_translations
        backends.each do |backend|
          backend.instance_eval do
            init_translations
          end
        end
      end
    end
  end
end

module I18n
  module Backend
    class ActiveRecord
      def initialized?
        true
      end

      protected

      def translations
        res = {}

        I18n.available_locales.each do |locale_sym|
          trans = {}
          I18n::Backend::ActiveRecord::Translation.locale(locale_sym).find_each do |t|
            trans_pointer = trans
            key_array = t.key.split(".")
            last_key = key_array.delete_at(key_array.length-1)
            key_array.each do |current|
              if !trans_pointer.has_key?(current.to_sym)
                trans_pointer[current.to_sym] = {}
              end
              trans_pointer = trans_pointer[current.to_sym]
            end
            puts "#{[last_key.to_sym]} = #{t.value}"
            trans_pointer[last_key.to_sym] = t.value
          end
          res[locale_sym] = trans
        end
        return res
      end

      def init_translations
      end
    end
  end
end

module I18n
  module Backend
    class KeyValue
      def initialized?
        true
      end

    protected
      def translations
        trans = {}
        store.keys.delete_if{|k| k.include?("#")}.each do |k|
          trans_pointer = trans
          key_array = k.split(".")
          last_key = key_array.delete_at(key_array.length-1)
          key_array.each do |current|
            if !trans_pointer.has_key?(current.to_sym)
              trans_pointer[current.to_sym] = {}
            end
            trans_pointer = trans_pointer[current.to_sym]
          end
          trans_pointer[last_key.to_sym] = store[k]
        end
        return trans
      end

      def init_translations
      end
    end
  end
end

I18n.backend = I18n::Backend::Simple.new

I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)
I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)
I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)
I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Flatten)

I18n.backend = I18n::Backend::Chain.new(I18n::Backend::ActiveRecord.new, I18n.backend)
