class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string, comment:'头像'
  end
end
