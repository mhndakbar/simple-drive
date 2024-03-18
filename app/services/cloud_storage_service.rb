class CloudStorageService < StorageService
  OSS_ENDPOINT = Rails.application.credentials[:alibaba_cloud_oss][:endpoint]
  ACCESS_KEY_ID = Rails.application.credentials[:alibaba_cloud_oss][:access_key_id]
  ACCESS_KEY_SECRET = Rails.application.credentials[:alibaba_cloud_oss][:access_key_secret]
  OSS_BUCKET = Rails.application.credentials[:alibaba_cloud_oss][:bucket_name]

  def store_blob
    uri = URI.parse("#{OSS_ENDPOINT}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    if file_exists?(uri)
      raise "File with ID #{@blob_params[:id]} already exists."
    end

    request = Net::HTTP::Put.new("/#{@blob_params[:id]}")
    request.body = @blob_params[:data]
    request["Content-Type"] = "text/plain"
    request["Content-Length"] = @blob_params[:data].bytesize.to_s
    request["Date"] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
    request["Authorization"] = sign_request(request)

    response = http.request(request)

    raise "Failed to upload to OSS: #{response.code} - #{response.message}" unless response.code == "200"

    BlobMetadata.create!(blob_id: @blob_params[:id], owner_id: @current_user.id, size: @decoded_data.bytesize)
  end

  def retrieve_blob
    # Database storage logic here
  end

  private

  def file_exists?(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new("/#{@blob_params[:id]}")
    request["Date"] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
    request["Authorization"] = sign_request(request)

    response = http.request(request)

    return response.code == "200"
  end

  def sign_request(request)
    string_to_sign = "#{request.method}\n\n#{request["Content-Type"]}\n#{request["Date"]}\n/#{OSS_BUCKET}/#{@blob_params[:id]}"
    signature = OpenSSL::HMAC.digest("sha1", ACCESS_KEY_SECRET, string_to_sign)
    "OSS #{ACCESS_KEY_ID}:#{Base64.strict_encode64(signature)}"
  end
end
