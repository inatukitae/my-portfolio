class CreateReflections < ActiveRecord::Migration[8.0]
  def change
    create_table :reflections do |t|
      t.references :post, null: false, foreign_key: true
      t.text :solution
      t.text :prevention

      t.timestamps
    end
  end
end
