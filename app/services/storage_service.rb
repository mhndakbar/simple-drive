class StorageService
  def initialize(blob_params, current_user, decoded_data)
    @blob_params = blob_params
    @current_user = current_user
    @decoded_data = decoded_data
  end

  def store_blob
    raise NotImplementedError, 'Subclasses must implement this method'
  end

  def retrieve_blob
    raise NotImplementedError, 'Subclasses must implement this method'
  end
end
