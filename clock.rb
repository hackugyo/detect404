# -*- coding: utf-8 -*-
require 'clockwork'
require './tweet.rb'
require 'pp'

include Clockwork

handler do |job|
  #puts "Running #{job}"
  @twitter ||= Tweet.new
  @twitter.get_tweet_with_404_links.each do |tweet|
    next if (tweet[:links].empty?)
    puts "#{tweet[:tweet][:text]}"
    puts "Your link is dead! #{tweet[:links].map{|link| link.to_s}}"
    # ここで404リンクのやつに対してtweetする
    # tweet[:tweet]
    @twitter.notify_404(tweet[:tweet], tweet[:links])
  end  
end

every(61.seconds, 'frequent.job')
