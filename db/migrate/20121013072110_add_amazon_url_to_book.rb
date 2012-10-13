class AddAmazonUrlToBook < ActiveRecord::Migration
  def change
    add_column :books, :amazon_url, :text
  end
end
