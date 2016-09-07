class CreateStickerConfigs < ActiveRecord::Migration
  def change
    create_table :sticker_configs do |t|
      t.integer :key, comment: '按键编号'
      t.string :value, comment: '按键代表的评论内容'
      t.integer :teacher_id, comment: '关联教师'
      t.timestamps null: false
    end
  end
end
