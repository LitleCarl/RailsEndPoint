class CreateClazzs < ActiveRecord::Migration
  def change
    create_table :clazzs do |t|
      t.string :grade, comment: '年级'
      t.string :number, comment: '班级号'
      t.integer :room_id, comment: '班级所在的房间id'
      t.timestamps null: false
    end
  end
end