class AddGenderAndAvatarToStudent < ActiveRecord::Migration
  def change
    add_column :students, :gender, :string, comment: '性别'
    add_column :students, :avatar, :string, comment: '头像'
  end
end
