namespace :itunes do
  desc "itunes検索の動作確認タスク"

  task :search, 'keyword'
  task :search do |t, args|
    require "#{Rails.root}/app/controllers/concerns/itunes_adapter.rb"
    ItunesAdapter.search args['keyword']
  end
end
