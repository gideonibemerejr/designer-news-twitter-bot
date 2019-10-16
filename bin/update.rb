# require 'dotenv/load'
require 'twitter'
require 'httparty'
require 'nokogiri'


twitter = Twitter::REST::Client.new do |config|
    config.consumer_key = 'UpQ3kFSrbYQsXoFAvSRxHJrJf'
    config.consumer_secret = 'A96SU1rlxdglCQjwxmktRaQa2t2cqVshAPFl0XR59qpHmZkyvv'
    config.access_token = '4709673841-JDG2jU5WTLnhj1XGmtLF371H4hGY1kzuFcY7pUd'
    config.access_token_secret = 'QXCqIN3CYO23r3FSW91ztBD9J26wzfy80HvgrcAClXZnP'
end

latest_tweets = twitter.user_timeline('esrosn')

previous_links = latest_tweets.map do |tweet|
    if tweet.urls.any?
        tweet.urls[0].expanded_url
    end
end

rss = HTTParty.get('https://www.designernews.co/?format=rss')
doc = Nokogiri::XML(rss)

doc.css('item').take(5).each do |item|
    title = item.css('title').text
    link = item.css('description').text

    unless link.start_with?('http')
        link = item.css('link').text
    end

    unless previous_links.include?(title)
        twitter.update("#{title} #{link}")
    end
end



