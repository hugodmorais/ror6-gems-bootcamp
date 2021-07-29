class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.integer :course_tags_counter, null: false, default: 0

      t.timestamps
    end
  end
end
