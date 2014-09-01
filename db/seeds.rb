# encoding: utf-8
require 'json'

# ------------------------------------------------------------
# Configファイル読み出し

config_file_path = './db/seeds.json'
begin
  f = File.open(config_file_path)
  json_data = JSON.parse(f.read)
rescue
  # Configファイルが不正な構文 => 終了する
  puts "\e[31m seeds.json is invalid \e[0m"
  exit
end

festivals = json_data['festivals']

# ------------------------------------------------------------
# 登録処理

# 一旦削除
Festival.destroy_all
Artist.destroy_all
Appearance.destroy_all
FestivalDate.destroy_all


# 各モデルのIDは連番にする
festival_id = 1
festival_date_id = 1
appearance_id = 1  
artist_id = 1


# Configで設定したfes情報を1件ずつ登録していく
festivals.each do | festival |

  # "フェス単位の情報"を登録
  # Festivalsテーブル(フェス名、オフィシャルサイトURL)
  puts "insert #{festival['name']}"
  Festival.create do | f |
    f.id = festival_id
    f.name = festival['name']
    f.path_key = festival['path_key']
    f.official_site = festival['official_site']
  end

  # "日付単位の情報"を登録
  festival['daily_info'].each do | festival_daily |
    puts "  #{festival_daily['date']}"

    # FestivalDatesテーブル(日時、場所)
    year  = festival_daily['date'].slice(0..3).to_i
    month = festival_daily['date'].slice(4..5).to_i
    day   = festival_daily['date'].slice(6..7).to_i

    FestivalDate.create do | fd |
      fd.id = festival_date_id
      fd.festival_id = festival_id
      fd.place = festival_daily['place']
      fd.date = DateTime.new(year, month, day)
      fd.path_key = "#{year}-#{month}-#{day}-#{festival_daily['place_key']}"
    end

    # Appearancesテーブル(登録されていない場合はArtistテーブルも)
    File.open(Rails.root.to_s + festival_daily['file']) do | f |
      # 1行ずつファイルを読み出し
      f.each do | line |
        line.chomp!
        artist_data = line.split("\t")
        # 日付が一致したものだけ処理を行う
        if festival_daily['date'] == artist_data[2]
          # Artistが既に登録されていない場合は、登録を行う
          tmp_artist = Artist.where(path_key: artist_data[1]).last
          unless tmp_artist
            Artist.create do | artist |
              artist.id = artist_id
              artist.name = artist_data[0]
              artist.path_key = artist_data[1]
            end
            tmp_artist_id = artist_id
          else
            tmp_artist_id = tmp_artist.id
          end

          # Appearanceはどっちにしろ登録
          Appearance.create do | ap |
            ap.festival_date_id = festival_date_id
            ap.artist_id = tmp_artist_id
          end
          artist_id += 1
        end
      end
    end
    festival_date_id += 1
  end

  festival_id += 1
end

