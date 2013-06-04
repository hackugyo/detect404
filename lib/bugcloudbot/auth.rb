# -*- coding: utf-8 -*-
module BugcloudBot
  class Auth
    # アクセストークンを取得
    def self.get_acceess_token
      consumer = OAuth::Consumer.new(
                                     BugcloudBot::Tokens::CONSUMER_KEY,
                                     BugcloudBot::Tokens::CONSUMER_SECRET,
                                     {
                                       :site => 'http://api.twitter.com',
                                       :request_token_path => '/oauth/request_token',
                                       :authorize_path => '/oauth/authorize',
                                       :access_token_path => '/oauth/access_token'
                                     }
                                     )

      OAuth::AccessToken.new(
                             consumer,
                             BugcloudBot::Tokens::ACCESS_TOKEN,
                             BugcloudBot::Tokens::ACCESS_TOKEN_SECRET
                             )
    end

    # Rubytterインスタンスを取得
    def self.get_oauth_rubytter
      OAuthRubytter.new(get_acceess_token)
    end

  end
end
