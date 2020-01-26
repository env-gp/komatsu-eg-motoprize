module VehicleDecorator
  def image?
    File.exist? "#{ Rails.root }/app/assets/images/vehicles/#{ self.id }.jpg"
  end

  def image_path
    "vehicles/#{ self.id }.jpg"
  end

  def movie_split
    self.movie.split(',')
  end
end