class DatabaseStorageService < StorageService
  def store_blob
    Blob.create!(id: @blob_params[:id], data: @blob_params[:data])
    BlobMetadata.create!(owner_id: @current_user.id, size: @decoded_data.bytesize)
  rescue ActiveRecord::RecordNotUnique => e
    raise ArgumentError, e.message
  end

  def retrieve_blob
    blob = Blob.find_by(id: @blob_params[:id].to_s)

    return nil unless blob.present?

    blob_metadata = BlobMetadata.find_by(blob_id: blob.id)

    {
      id: blob.id,
      data: blob.data,
      size: blob_metadata.size,
      created_at: blob.created_at.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    }
  rescue => e
    raise "Failed to retrieve blob from database storage: #{e.message}"
  end
end
