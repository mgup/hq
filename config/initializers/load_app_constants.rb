require 'yaml'
require 'erb'

def process_constants_hash(data, current_key = 'MGUP')
  if data.is_a? Hash
    data.each do |key, value|
      process_constants_hash(value, [current_key, key.to_s.upcase].join('_'))
    end
  else
    Kernel.const_set(current_key, data)
  end
end
costants_file = File.open("#{Rails.root}/config/constants.yml").read
process_constants_hash(YAML::load(ERB.new(costants_file).result))