# -*- coding: utf-8 -*-
require 'twitter'
require 'pp'
require 'net/http'

class Tweet

    CONSUMER_KEY        = 'hCJN1uRHUMozhTJRuShvBA'
    CONSUMER_SECRET     = 'lvB3LfVslGI1Gj06uwcEXd4iwCtSjSHGpiTcjwRw'
    ACCESS_TOKEN        = '1479607813-EOnL0WcsABb5aG3lrwr19JdIooucNUaloobK6iB' #'<ACCESS_TOKEN>'
    ACCESS_TOKEN_SECRET = 'vlpfWx6jhQpDRN1EgnSFbFfnNgBELYavLAOQjrSdgY'

  def initialize
    Twitter.configure do |config|
      config.consumer_key       = CONSUMER_KEY
      config.consumer_secret    = CONSUMER_SECRET
      config.oauth_token        = ACCESS_TOKEN
      config.oauth_token_secret = ACCESS_TOKEN_SECRET
    end
  end

  def daily_tweet
    tweet = @text[Time.now.day - 1]
    update(tweet)
  end

  puts @last_id

  def notify_404(tweet, links = [])
    # TODO linksを発射するかどうか
    begin
      Twitter.update(
                     get_notify_message(tweet[:user][:screen_name]),
                     {:in_reply_to_status_id => tweet[:id]}
                     )
    rescue => ex
      puts ex
    end
  end
  
  
  def get_tweet_with_404_links
    tweets = home_timeline(@last_id)
    tweets ||= []
    last_id = nil
    tweets_with_404 = []
    tweets.each do |tweet|
      last_id ||= tweet.attrs[:id]

      # 対象外のツイートを削除
      next if tweet.attrs[:retweeted_status]

      # 本文がリンクを含んでいるかどうかを抜き出す
      links = extract_links(tweet.attrs[:text])
            
      links.select! do |link|
        is40x?(link)
      end

      # TODO ここで，linksとtweetでできたハッシュを作って返す
      tweets_with_404 << {:tweet => tweet, :links => links}
            
    end
    @last_id = last_id if last_id
    puts @last_id.to_s

    return tweets_with_404
  end
  
  private
  def update(tweet)
    return nil unless tweet

    begin
      Twitter.update(tweet.chomp)
    rescue => ex
      nil # todo
    end
  end

  def home_timeline(last_id)
    begin
      # TODO since_idのようなoptionsを設定すること．
      # https://dev.twitter.com/docs/api/1/get/statuses/home_timeline
      options = {}
      options[:since_id] = last_id if last_id
      Twitter.home_timeline(options)
    rescue => ex
      puts "error."
      p ex
      []
    end
  end

  def extract_links(text)
    result = []
    uri_reg = URI.regexp(['http','https'])
    text.scan(uri_reg) do
      result << URI.parse($&)
    end
    
    return result
  end

  # http://doc.ruby-lang.org/ja/1.9.2/library/net=2fhttp.html
  def is40x?(uri_str, limit = 10)
    
    return true if limit == 0 # 10回たらいまわしされたら404と考える
    begin
      response = Net::HTTP.get_response(URI.parse(uri_str.to_s))
    rescue EOFError
      puts "EOFError. Regard as not dead. #{uri_str}"
      return false
    rescue => ex
      puts "Error occured. Regard as dead. #{uri_str}"
      p ex
      # puts "This link is dead! #{uri_str}"
      return true
    end
    
      
    case response
    when Net::HTTPFatalError
      # puts "This link is dead! #{uri_str}"
      true
    when Net::HTTPClientError
      # puts "This link is dead! #{uri_str}"
      true
    when Net::HTTPRedirection
      # リダイレクト対応
      # puts "This link is redirected. #{uri_str}"
      # puts "  to #{response['location']}"
      # pp response
      # "http://www.kantei.go.jp/fake"にアクセスすると302で終わっている？
      is40x?(response['location'], limit -1)
    else
      # pp response
      # puts "This link is not dead. #{uri_str}"
      false
    end
  end

  def get_notify_message(screen_name)
    lines = NOTIFY_MESSAGE_DICTIONARY.rstrip.split(/\r?\n/).map {|line| line.chomp }
    "@#{screen_name} #{lines[rand(lines.length)]}"
  end

  NOTIFY_MESSAGE_DICTIONARY = <<'EOS'
リンクが404です
リンクが404だよ！
◆リン◆ ドーモ、404探偵です。リンク直すべし◆殺◆

EOS
end
