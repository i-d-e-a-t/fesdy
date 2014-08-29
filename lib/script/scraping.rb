#!/Users/nakamurasousuke/.rvm/rubies/ruby-2.0.0-p481/bin/ruby

# Scrapingに必要な以下の情報を対話式に収集する
# - アウトプット先のファイル名
# (開催日が複数あるなら以下は繰り返し入力する
# - フェスの開催日
# - アーティストページのURL
# - スクレイピング
#


def ask_scraping_at

  # ファイル名
  scraping_config = {}
  scraping_config[:file] = ask 'please type output file name'

  # additional_rules
  additional_rules = []
  answer = ''
  while answer != 'n'
    answer = ask 'please input additional rules (if you dont need additonal_rules => type \'n\''
    additional_rules << answer if answer != 'n'
  end
  

  tmp_ary = []
  is_continue = true
  while is_continue
    info = {}
    info[:date] = ask 'please type festival date (yyyyddmm)'
    info[:url]  = ask 'please type artist page url'
    info[:css]  = ask 'please type selector(css) for scraping'
    tmp_ary << info

    # 繰り返すか聞く
    answer = ask 'continue?(y or n)'
    is_continue = false if answer == 'n'
  end
  
  scraping_config[:config_by_date] = tmp_ary

  return scraping_config
end

def ask question
  puts "#{question}"
  answer = ''
  while answer.length == 0
    print ' > '
    answer = gets.chomp
  end
  return answer
end

### main

# 




