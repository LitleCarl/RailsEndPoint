class CreatePayloads < ActiveRecord::Migration
  def change
    create_table :payloads do |t|
      t.integer :student_id, null: false, comment: '所属学生'
      t.integer :station_id, null: false, comment: '所属基站'
      t.integer :strength, default: 0, comment: '信号强度'
      t.integer :token, comment: '当前数据组token'
      t.timestamps null: false
    end
  end
end
