# -*- coding: utf-8 -*-
require 'clockwork'
require './tweet.rb'
require 'pp'

include Clockwork

handler do |job|
  #puts "Running #{job}"
  @twitter ||= Tweet.new
  @twitter.get_tweet_with_404_links.each do |tweet|
    # ここで404リンクのやつに対してtweetする 
  end  
end

every(61.seconds, 'frequent.job')
