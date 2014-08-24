# encoding: utf-8

# ------------------------------------------------------------
# Config投入

festivals = []

# TODO: 本当はJSONとかで別ファイルに切り出したほうがいいと思う。

# 以下のテンプレートに追加したいフェスの情報を書いて、増やしていく
#festivals << {
#  name: ,
#  path_key: ,
#  official_site: ,
#  daily_info: [
#    {
#      place: ,
#      date:  , #=> yyyyddmm形式で
#      file:  , #=> [Artist名 path_key yyyymmdd形式の出演日]がタブ区切りで
#                 書かれているファイルのパスを渡す
#    },
#    {
#      place: ,
#      date:  ,
#      file:  
#    }
#}

# SUMMER SONIC 2014
festivals << {
  path_key: 'summer-sonic-2014',
  name: 'SUMMER SONIC 2014',
  official_site: 'http://www.summersonic.com/2014/',
  daily_info: [
    {
      place: '東京：QVCマリンフィールド＆幕張メッセ',
      place_key: 'tokyo',
      date: '20140816',
      file: '/lib/script/summer-sonic-2014.artists.tokyo'
    },
    {
      place: '東京：QVCマリンフィールド＆幕張メッセ',
      place_key: 'tokyo',
      date: '20140817',
      file: '/lib/script/summer-sonic-2014.artists.tokyo'
    },
    {
      place: '大阪：舞洲サマーソニック大阪特設会場',
      place_key: 'osaka',
      date: '20140816',
      file: '/lib/script/summer-sonic-2014.artists.osaka'
    },
    {
      place: '大阪：舞洲サマーソニック大阪特設会場',
      place_key: 'osaka',
      date: '20140817',
      file: '/lib/script/summer-sonic-2014.artists.osaka'
    }
  ]
}

# a-nation 2014
festivals << {
  path_key: 'a-nation-2014',
  name: 'a-nation 2014',
  official_site: 'http://a-nation.net/',
  daily_info: [
    {
      place: '東京：味の素スタジアム',
      place_key: 'tokyo',
      date: '20140829',
      file: '/lib/script/a-nation-2014.artists'
    },
    {
      place: '東京：味の素スタジアム',
      place_key: 'tokyo',
      date: '20140830',
      file: '/lib/script/a-nation-2014.artists'
    },
    {
      place: '東京：味の素スタジアム',
      place_key: 'tokyo',
      date: '20140831',
      file: '/lib/script/a-nation-2014.artists'
    }
  ]
}

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
  puts "insert #{festival[:name]}"
  Festival.create do | f |
    f.id = festival_id
    f.name = festival[:name]
    f.path_key = festival[:path_key]
    f.official_site = festival[:official_site]
  end

  # "日付単位の情報"を登録
  festival[:daily_info].each do | festival_daily |
    puts "  #{festival_daily[:date]}"

    # FestivalDatesテーブル(日時、場所)
    year  = festival_daily[:date].slice(0..3).to_i
    month = festival_daily[:date].slice(4..5).to_i
    day   = festival_daily[:date].slice(6..7).to_i

    FestivalDate.create do | fd |
      fd.id = festival_date_id
      fd.festival_id = festival_id
      fd.place = festival_daily[:place]
      fd.date = DateTime.new(year, month, day)
      fd.path_key = "#{year}-#{month}-#{day}-#{festival_daily[:place_key]}"
    end

    # Appearancesテーブル(登録されていない場合はArtistテーブルも)
    File.open(Rails.root.to_s + festival_daily[:file]) do | f |
      # 1行ずつファイルを読み出し
      f.each do | line |
        line.chomp!
        artist_data = line.split("\t")
        # 日付が一致したものだけ処理を行う
        if festival_daily[:date] == artist_data[2]
          # Artistが既に登録されていない場合は、登録を行う
          tmp_artist = Artist.where(path_key: artist_data[1]).last
          unless tmp_artist
            Artist.create do | artist |
              artist.id = artist_id
              artist.name = artist_data[0]
              artist.path_key = artist_data[0]
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

