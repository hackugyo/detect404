require 'clockwork'
require './tweet.rb'
require 'pp'

include Clockwork

handler do |job|
  #puts "Running #{job}"
  Tweet.new.get_home_timeline.each do |tweet|
    pp tweet
    puts tweet.attrs[:text]
  end
  
end

every(61.seconds, 'frequent.job')
