class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.text :event, null: false
      t.text :emotion, null: false
      t.text :issue, null: false

      t.timestamps
    end
  end
end