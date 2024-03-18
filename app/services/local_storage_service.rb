class LocalStorageService < StorageService
  def store_blob
    storage_directory = SimpleDrive::LOCAL_STORAGE_PATH

    FileUtils.mkdir_p(storage_directory) unless File.directory?(storage_directory)

    if File.exist?(File.join(storage_directory, @blob_params[:id]))
      raise ArgumentError, 'A file with the same ID already exists'
    end

    File.open(File.join(storage_directory, @blob_params[:id]), 'wb') do |file|
      file.write(@blob_params[:data])
    end

    BlobMetadata.create!(blob_id: @blob_params[:id], owner_id: @current_user.id, size: @decoded_data.bytesize)
  rescue => e
    raise "Failed to store file in local storage: #{e.message}"
  end

  def retrieve_blob
    storage_directory = SimpleDrive::LOCAL_STORAGE_PATH
    file_path = File.join(storage_directory, @blob_params[:id])

    return nil unless File.exist?(file_path)

    data = File.read(file_path)

    blob_metadata = BlobMetadata.find_by(blob_id: @blob_params[:id])

    {
      id: @blob_params[:id],
      data: data,
      size: blob_metadata.size,
      created_at: blob_metadata.created_at.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    }
  rescue => e
    raise "Failed to retrieve file from local storage: #{e.message}"
  end
end
