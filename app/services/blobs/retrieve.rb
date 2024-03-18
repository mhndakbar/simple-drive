module Blobs
  class Retrieve
    def initialize(blob_params, current_user)
      @blob_params = blob_params
      @current_user = current_user
    end

    def call
      storage_service.retrieve_blob
    rescue StandardError => e
      raise e
    end

    private

    def storage_service
      case SimpleDrive::STORAGE_SERVICE
      when SimpleDrive::STORAGE_OPTIONS[:database]
        DatabaseStorageService.new(@blob_params, @current_user, nil)
      when SimpleDrive::STORAGE_OPTIONS[:local_storage]
        LocalStorageService.new(@blob_params, @current_user, nil)
      when SimpleDrive::STORAGE_OPTIONS[:cloud]
        CloudStorageService.new(@blob_params, @current_user, nil)
      else
        raise ArgumentError, 'Invalid storage service configuration'
      end
    end
  end
end