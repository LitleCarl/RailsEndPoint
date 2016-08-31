class CreateFloors < ActiveRecord::Migration
  def change
    create_table :floors do |t|
      t.string :name, comment: '楼层名称'
      t.text :image, comment: '楼层cad图'

      t.timestamps null: false
    end
  end
end
