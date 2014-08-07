# utf-8

# config/secrets.ymlを利用する場合、
# 環境によっていくらかの影響を考慮する必要がある。
#     - 環境変数で代用(secrets.ymlが使えない場合)
#     - secrets.ymlが使える場合
# このモジュールではこれらの差分を吸収するメソッドを提供する。
#
module SecretKeeper

  # 秘密の値を取得する。
  # 環境変数を優先する。
  #
  # key: config/secrets.ymlのキー、
  #      または環境変数名のlowerケース
  #
  # 例：key = :youtube_apikey
  #
  # config/secrets.yml
  # |
  # |development:
  # |  ....
  # |  youtube_apikey: "..." <-- これ
  #
  # または、環境変数の「YOUTUBE_APIKEY」
  def secret key
    env_key = key.upcase.to_s
    return ENV[env_key] ? ENV[env_key] : Rails.application.secrets[key]
  end
end
