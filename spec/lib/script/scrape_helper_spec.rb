require 'rails_helper'
# 対象ファイルを読み込む
require File.join Rails.root, 'lib', 'script', 'scrape_helper'

OUTPUT_FILENAME = 'awesome-2014.artists'
DATE_KEY = '20990831'
ARTISTS = [
  'アーティスト1  ',
  'アーティスト2   ',
  '　　アーティスト3'
]
HTML_UPPER_HALF = %(
  <html>
  <body>
    <div id="artists">
      <ul>
)
HTML_UNDER_HALF = %(
      </ul>
    </div>
  </body>
  </html>
)

# テスト用HTMLを作るメソッド
def ul_html(array, &block)
  middle = array.map(&block)
  "#{ HTML_UPPER_HALF }\n#{ middle }\n#{ HTML_UNDER_HALF }"
end

#
# テスト用HTML
#
HTML_SIMPLE = ul_html(ARTISTS) do |artist|
  "<li>#{artist}</li>\n"
end
HTML_WITH_IMAGE_ALT = ul_html(ARTISTS) do |artist|
  %(<li><img src="aaa.jpg" alt=#{artist} /></li>)
end

####################################################################
# サンプル
#

describe ScrapeHelper do
  describe '#old_name_of' do
    let(:original_name) { 'thisisfile' }
    subject { old_name_of original_name }
    it { should eq original_name + '.old' }
  end

  describe '#generate_artists_file' do
    #
    # 値準備
    #

    let(:file_dst) { StringIO.new '', 'w' }

    before do
      # ファイル出力をスタブ
      @output = info[:output]
      allow(::File).to receive(:open)
        .with(@output, 'a')
        .and_yield(file_dst)

    end
    #
    # 共通サンプル
    #
    shared_examples_for 'アーティストファイルを出力' do
      it 'output ***.artists file' do
        expect(file_dst.string).not_to be_empty
      end

      it 'output as <artist>\t<date_key>' do
        expect(file_dst.string).to eq([
          "アーティスト1\t20990831\n",
          "アーティスト2\t20990831\n",
          "アーティスト3\t20990831\n"
        ].join)
      end
    end

    context 'for simple html (<li> is artist name)' do
      let(:info) do
        {
          url: 'aaaaaaa',
          css: '#artists li',
          date_key: DATE_KEY,
          output: OUTPUT_FILENAME
        }
      end
      before do
        allow_any_instance_of(Object).to receive(:nokogiri_html)
          .and_return(Nokogiri::HTML HTML_SIMPLE)

        # 実行
        generate_artists_file info
      end
      it_behaves_like 'アーティストファイルを出力'
    end

    context 'for complex html (img[alt] is artist name)' do
      let(:info) do
        {
          url: 'aaaaaaa',
          css: '#artists li img',
          date_key: DATE_KEY,
          output: OUTPUT_FILENAME
        }
      end
      before do
        allow_any_instance_of(Object).to receive(:nokogiri_html)
          .and_return(Nokogiri::HTML HTML_WITH_IMAGE_ALT)

        # 実行
        generate_artists_file(info) do |html_node|
          html_node['alt']
        end
      end
      it_behaves_like 'アーティストファイルを出力'
    end
  end
end
