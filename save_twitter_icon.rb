require 'shangrila'

def connect_twitter(master)
  require './twitter.rb'
 @tw.users(account_list).each do |user|
   image_url = user.profile_image_url.to_s
   filename = './html/image/twitter_icon_' + @master_map[user.screen_name]

   puts image_url
   puts filename


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
