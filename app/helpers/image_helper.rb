module ImageHelper
  
  def user_image(user, class_string)
    if user.avatar.attached?
      image_tag user.thumbnail, class: class_string
    else
      image_tag User::DEFAULT_AVATER, class: class_string
    end
  end

  def vehicle_image(vehicle, class_string)
    if vehicle.image?
      label_tag :name, image_tag(vehicle.image_path, class: class_string), for: vehicle.name
    else
      label_tag :name, image_tag(Vehicle::NO_IMAGE_PATH, class: class_string), for: vehicle.name
    end
  end
end
