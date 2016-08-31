class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :device_id, comment: '基站设备id'
      t.integer :room_id, comment: '所属房间/走道id'
      t.string :group_number, comment: '同一房间内的基站编号'
      t.timestamps null: false
    end
  end
end
