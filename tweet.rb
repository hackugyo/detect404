# -*- coding: utf-8 -*-
require 'twitter'

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

  def get_home_timeline
    result = home_timeline
    result ||= []
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

  def home_timeline
    begin
      # TODO since_idのようなoptionsを設定すること．
      # https://dev.twitter.com/docs/api/1/get/statuses/home_timeline
      Twitter.home_timeline
    rescue => ex
      puts "error."
    end
  end

end
