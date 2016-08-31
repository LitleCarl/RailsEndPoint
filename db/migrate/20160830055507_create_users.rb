class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, comment: '用户名'
      t.string :password, null: false, comment: '密码'
      t.integer :permission, default: 0, comment: '权限bit'
      t.timestamps null: false
    end
  end
end
