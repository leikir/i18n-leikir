def to_dotted_hash(source, target = {}, namespace = nil)
  prefix = "#{namespace}." if namespace
  case source
  when Hash
    source.each do |key, value|
      to_dotted_hash(value, target, "#{prefix}#{key}")
    end
  when Array
    source.each_with_index do |value, index|
      to_dotted_hash(value, target, "#{prefix}#{index}")
    end
  else
    target[namespace] = source
  end
  target
end

desc 'turns locale yml files to db files'
task :translation => :environment do

  require 'yaml'

  override = ENV['override'] == "true"

  puts "starting translation conversion; override = #{override}"

  dirname = "config/locales/"

  Dir.glob(dirname + '*.yml') do |filename|
    puts "opening " + filename
    content = YAML::load(File.open(filename))

    content.each do |locale, nested|

      dot_hash = to_dotted_hash(nested)

      dot_hash.each do |key, value|

#        if value.nil?
#          value = value.to_s
#        end
        puts "locale =  " + locale + "; key = " + key + "; value = " + value.to_s

        model = Translation.where(
          locale: locale,
          key: key
       ).first_or_initialize
        if model.new_record? || override == true
          model.value = value
          model.save
        end
      end

    end

  end

end

