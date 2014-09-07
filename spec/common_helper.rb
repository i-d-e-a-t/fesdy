# encoding: utf-8
#
# 複数のテストコードで用いる
# 共通的な処理（データ準備とか）を定義する。
# モジュールは自動でincludeするので
# 各テストコードではメソッドのみ呼ぶこと。
module CommonHelper
  
  class Options
    def initialize data={}
      @data = data
    end
    def self.load data={}
      self.new data
    end

    def get key, default
      @data.has_key?(key) ? @data[key] : default
    end
  end

  # 日付による順序を見るためのfestivalとfestival_date
  def help_fes_order fes_num, date_num, options={}
    opts = Options.new options
    # オプション抽出
    date_offset = opts.get :date_offset, 0
    fes_path_key_base = opts.get :fes_path_key_base, 'awesome-festival-'

    # fes_numの数のフェスを作成
    fes_num.times do |i|
      festival = Festival.create(
        name: "すごいフェス#{i}",
        path_key: "#{fes_path_key_base}#{i}"
      )
      # 各フェスに、date_numの数のフェス開催日を作成
      # ただし、日付は
      # 「フェスの通番 + そのフェスのフェス開催日の通番 + オフセット」分ずれる。
      # 例： help_fes_order 5, 3, { date_offset: -2 }
      #
      #    fes0
      #      |---date0( 0 + 0 - 2 )
      #      |---date1( 0 + 1 - 2 )
      #      |---date2( 0 + 2 - 2 )
      #    fes1
      #      |---date0( 1 + 0 - 2 )
      #      |---date1( 1 + 1 - 2 )
      #      ...
      #
      date_num.times do |j|
        date_count = i + j + date_offset
        festival_date = FestivalDate.create(
          place: "すごいメッセ#{i}-#{j}",
          # 古い順に登録する。オフセットがアレばずらす。
          date: DateTime.now + date_count,
          festival_id: festival.id,
          path_key: "2014-08-06-Chiba#{i}-#{j}"
        )
      end
    end
  end

  # 終わったフェスと、終わってないフェスを作成
  def help_finished_fes_with_date date_num
    help_fes_order(1, date_num, {date_offset: (-1 - date_num), fes_path_key_base: 'finished_'})
    help_fes_order(1, date_num, {date_offset: 1, fes_path_key_base: 'not_finished_'})
  end

  # 最低限の情報をもつ各モデルを作成する。
  def help_create_models_for_relations
    festival = Festival.create(
      name: 'すごいフェス',
      path_key: 'awesome-festival-2014'
    )
    festival_date = FestivalDate.create(
      place: 'すごいメッセ',
      date: DateTime.now,
      festival_id: festival.id,
      path_key: '2014-08-06-Chiba'
    )
    artists = []
    artists << Artist.create(
      name: 'すごい奴らfeat.ヤバい奴ら'
    )
    artists << Artist.create(
      name: 'amazing Artist'
    )
    artists.each do |artist|
      Appearance.create(
        festival_date_id: festival_date.id,
        artist_id: artist.id
      )
    end
  end
end
