class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :teacher_id, null: false, comment: '关联教师'
      t.integer :student_id, null: false, comment: '关联学生'
      t.string :content, null: false, comment: '评论内容'

      t.timestamps null: false
    end
  end
end
