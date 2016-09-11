class CreateAudioMessages < ActiveRecord::Migration
  def change
    create_table :audio_messages do |t|
      t.integer :teacher_id, comment: '关联教师'
      t.integer :student_id, comment: '关联学生'
      t.string :audio, comment: '音频地址'
      t.boolean :readed, default: false, comment: '已读'
      t.timestamps null: false
    end
  end
end
