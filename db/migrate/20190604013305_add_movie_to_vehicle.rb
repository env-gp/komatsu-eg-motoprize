class AddMovieToVehicle < ActiveRecord::Migration[5.2]
  def change
    add_column :vehicles, :movie, :string
  end
end
