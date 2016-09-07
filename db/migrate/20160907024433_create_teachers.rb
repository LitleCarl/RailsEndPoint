class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :user_id, null: false, comment: '关联用户'
      t.string :name, null: false, comment: '名字'
      t.string :device_id, null: false, comment: '教师手环设备号'
      t.string :subject, comment: '学科'
      t.timestamps null: false
    end
  end
end
