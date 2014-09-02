require 'yaml'

namespace :itunes do

  desc "itunes検索の動作確認タスク"
  task :search, 'keyword'
  task :search do |t, args|
    puts "#" + "-"*70
    puts "#  itunes search API test"
    puts "#  term: #{args['keyword']}"
    puts "#  "
    puts "#  this task output result as YAML,"
    puts "#  please redirect it to *.yml when you re-use"
    puts "#" + "-"*70
    require "#{Rails.root}/app/controllers/concerns/itunes_adapter.rb"
    puts ItunesAdapter.search(args['keyword']).to_yaml
  end
end
