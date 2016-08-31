class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name, comment: '房间名称'
      t.text :location, comment: '房间坐标(相对楼层)'
      t.integer :floor_id, comment: '所属楼层id'

      t.timestamps null: false
    end
  end
end