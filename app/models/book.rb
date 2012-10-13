class Book < ActiveRecord::Base
  attr_accessible :amazon_item_id, :image_url, :qiita_tips, :qiita_title, :title, :user_id
end
