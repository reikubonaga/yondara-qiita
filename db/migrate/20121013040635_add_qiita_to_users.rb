class AddQiitaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :qiita_user, :string
    add_column :users, :qiita_token, :text
  end
end
