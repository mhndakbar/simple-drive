module Blobs
  class Create
    def initialize(blob_params, current_user)
      @blob_params = blob_params
      @current_user = current_user
    end

    def call
      decode_data!
      storage_service.store_blob
    rescue StandardError => e
      raise e
    end

    private

    def decode_data!
      @decoded_data = Base64Decoder.decode(@blob_params[:data])
      raise ArgumentError, 'Invalid base64 data' if @decoded_data.blank?
    end

    def storage_service
      case SimpleDrive::STORAGE_SERVICE
      when SimpleDrive::STORAGE_OPTIONS[:database]
        DatabaseStorageService.new(@blob_params, @current_user, @decoded_data)
      when SimpleDrive::STORAGE_OPTIONS[:local_storage]
        LocalStorageService.new(@blob_params, @current_user, @decoded_data)
      when SimpleDrive::STORAGE_OPTIONS[:cloud]
        CloudStorageService.new(@blob_params, @current_user, @decoded_data)
      else
        raise ArgumentError, 'Invalid storage service configuration'
      end
    end
  end
end