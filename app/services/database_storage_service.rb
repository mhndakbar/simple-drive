class DatabaseStorageService < StorageService
  def store_blob
    blob = Blob.create!(id: @blob_params[:id], data: @blob_params[:data])
    blob.create_blob_metadata!(owner_id: @current_user.id, size: @decoded_data.bytesize)
  rescue ActiveRecord::RecordNotUnique => e
    raise ArgumentError, e.message
  end

  def retrieve_blob
    # Database storage logic here
  end
end
