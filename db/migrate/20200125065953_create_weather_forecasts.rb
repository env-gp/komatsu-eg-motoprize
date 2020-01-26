class CreateWeatherForecasts < ActiveRecord::Migration[5.2]
  def change
    create_table :weather_forecasts do |t|
      t.references :prefecture, foreign_key: true, null: false
      t.integer :weather_id, null: false, comment: "天気の状態id"
      t.string :main, null: false, comment: "天気の状態"
      t.string :description, null: false, comment: "天気の詳細"
      t.datetime :acquired_at, null: false, comment: "APIで取得した日時"

      t.timestamps
    end
  end
end
