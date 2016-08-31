class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name, comment: '学生姓名'
      t.string :number, comment: '学号'
      t.string :device_id, comment: '手环设备号'
      t.integer :clazz_id, comment: '所属班级id'
      t.timestamps null: false
    end
  end
end
