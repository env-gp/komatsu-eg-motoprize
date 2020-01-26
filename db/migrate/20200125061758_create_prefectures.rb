class CreatePrefectures < ActiveRecord::Migration[5.2]
  def change
    create_table :prefectures do |t|
      t.string :name, null: false,  comment: "県名"
      t.integer "geonames_id", null: false, comment: "GeoNamesのid"

      t.timestamps
    end
  end
end
