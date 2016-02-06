require 'shangrila'
require 'faraday'

def save_image(url, download_file_path)
  http_conn = Faraday.new do |builder|
    builder.adapter Faraday.default_adapter
  end
  response = http_conn.get url
  File.open(download_file_path, 'wb') { |fp| fp.write(response.body) }
end

def connect_twitter(account_list)
  require './twitter.rb'
 @tw.users(account_list).each do |user|
   image_url = user.profile_image_url.to_s.gsub(/normal/,'bigger')
   ext = File.extname(image_url)
   filename = './html/image/twitter_icon_' + @master_map[user.screen_name].to_s + ext

   puts image_url
   puts filename
   save_image(image_url, filename)

 end
end

master = Shangrila::Sora.new().get_master_data(ARGV[0], ARGV[1])

@master_map = {}
account_list = []

master.each do |m|
  @master_map[m['twitter_account']] = m['id']
  account_list << m['twitter_account']
end

connect_twitter(account_list)
