class TeamImageUploader < CarrierWave::Uploader::Base
  if Rails.env.production? or Rails.env.staging?
    storage :file #todo change to fog
  else
    storage :file
  end

  def store_dir
    "uploads/images/teams/#{model.id}"
  end

  def default_url(*args)
    "/NoTeamImage.png"
  end

  def filename
    "image.#{file.extension}" if original_filename.present?
  end
end
