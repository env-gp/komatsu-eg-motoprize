class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :vehicle, index: true, foreign_key: true
      t.string :title, null: false
      t.string :body, null: false

      t.timestamps
    end
  end
end
