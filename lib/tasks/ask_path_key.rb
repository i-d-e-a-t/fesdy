# encoding: utf-8

class AskPathKey

  SPECIALS = ("- /.,:;&" +
              "ー　・。、：；＆").split ""

  RULES = [
    ('A'..'Z').to_a,
    ('a'..'z').to_a,
    ('0'..'9').to_a,
    ('Ａ'..'Ｚ').to_a,
    ('ａ'..'ｚ').to_a,
    ('０'..'９').to_a,
    SPECIALS
  ].flatten
  # 文字列を入力すると、１文字でも以下のルールに当てはまらない時
  # パスキーを質問する。
  #   英数字である（半角、全角、大文字、小文字)
  #
  # 第二引数で、特別変換する文字をハッシュで与える。
  # たいてい、値は空文字列に鳴るだろう。
  # 例：{'Opening Act' --> ''}
  #
  # 返り値は、特別変換を適用したクエリと
  # パスキーの配列。
  def self.ask query, ex={}
    # 特別変換する文字列の変換
    ex.each do |k, v|
      query.gsub!(k, v)
    end
    qs = query.split ''
    qs.each do |c|
      if RULES.include? c
        # 何もしない
      else
        # 質問
        puts "\e[31mplease path_key for [#{query}]\e[0m"
        path_key = ""
        while path_key.length == 0
          print " > "
          path_key = gets.chomp
        end
        puts "\e[32m#{query} ---> #{path_key}\e[0m"
        return [query, path_key]
      end
    end
    # path_keyが不要だったので、自動で変換する。
    path_key = self.make_path_key query
    return [query, path_key]
  end

  def self.make_path_key query
    zenkaku = [('Ａ'..'Ｚ').to_a, ('ａ'..'ｚ').to_a, ('０'..'９').to_a]
    zenkaku.flatten!
    hankaku = [('A'..'Z').to_a, ('a'..'z').to_a, ('0'..'9').to_a]
    hankaku.flatten!

    qs = query.split ''
    qs.each_with_index do |c, i|
      # 全角を半角にする。
      if zen_i = zenkaku.index(c)
        qs[i] = hankaku[zen_i]
      end
      # 半角でない文字はハイフンにする
      unless hankaku.index(c)
        qs[i] = '-'
      end
      # アンパサンドは'and'にする
      if c == '&' || c == '＆'
        qs[i] = 'and'
      end
    end
    path_key = qs.join.downcase
    puts "\e[32mAUTO CONVERT: #{query} ---> #{path_key}\e[0m"
    return path_key
  end
end
