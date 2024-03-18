module Blobs
  class Create
    def initialize(blob_params, current_user)
      @blob_params = blob_params
      @current_user = current_user
    end

    def call
      decode_data!
      create_blob!
    rescue StandardError => e
      raise e
    end

    private

    def decode_data!
      @decoded_data = Base64Decoder.decode(@blob_params[:data])
      raise ArgumentError, 'Invalid base64 data' if @decoded_data.blank?
    end

    def create_blob!
      blob = Blob.create!(id: @blob_params[:id], data: @blob_params[:data])
      blob.create_blob_metadata!(owner_id: @current_user.id, size: @decoded_data.bytesize)
    rescue ActiveRecord::RecordNotUnique => e
      raise ArgumentError, e.message
    end
  end
end