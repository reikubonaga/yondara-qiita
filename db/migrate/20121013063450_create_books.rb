class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :user_id
      t.string :amazon_item_id
      t.string :title
      t.string :image_url
      t.string :qiita_title
      t.text :qiita_tips

      t.timestamps
    end
  end
end
