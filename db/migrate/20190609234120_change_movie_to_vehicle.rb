class ChangeMovieToVehicle < ActiveRecord::Migration[5.2]
  class Vehicle < ActiveRecord::Base
  end
  
  def up
    Vehicle.reset_column_information
    Vehicle.where(movie: nil).update_all(movie: "")
    change_column :vehicles, :movie, :string, null: false
  end

  def down
    change_column :vehicles, :movie, :string, null: true
  end
end
