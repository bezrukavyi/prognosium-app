class AttachmentUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def serializable_hash
    url_path = url || metadata['url']
    filename = model.name || original_filename
    {
      filename: filename,
      url: url_path,
      type: resource_type,
      format: format
    }
  end
end
