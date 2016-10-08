class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.text :location, null: false, comment: '定位坐标json,比如[0.331, 0.455], 相对于room所属的floor'
      t.integer :student_id, null: false, comment: '学生id'
      t.integer :room_id, comment: '定位所在房间'
      t.text :extra, comment: '其他信息(JSON)'
      t.timestamps null: false
    end
  end
end
