class AddLocationToStation < ActiveRecord::Migration
  def change
    add_column :stations, :location, :text, comment: '基站坐标'
  end
end
