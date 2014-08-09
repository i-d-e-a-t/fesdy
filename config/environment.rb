# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# for Travis
if Rails.application.secrets.secret_key_base
  # config/secrets.ymlが存在する、
  # つまりローカル環境の場合、何もしない
  puts "Probably, there is config/secrets.yml"
else
  # secretsが設定されてない、つまりTravis
  # ランダムで128長の secret_key_base を作成、セットする
  puts "Probably, there isn't config/secrets.yml"
  chars = [('0'..'9').to_a, ('a'..'f').to_a].flatten
  generated_key = 128.times.collect { chars.sample }.join
  Rails.application.secrets.secret_key_base = generated_key
end
