class CloudStorageService < StorageService
  OSS_ENDPOINT = Rails.application.credentials[:alibaba_cloud_oss][:endpoint]
  ACCESS_KEY_ID = Rails.application.credentials[:alibaba_cloud_oss][:access_key_id]
  ACCESS_KEY_SECRET = Rails.application.credentials[:alibaba_cloud_oss][:access_key_secret]
  OSS_BUCKET = Rails.application.credentials[:alibaba_cloud_oss][:bucket_name]
  URI = URI.parse("#{OSS_ENDPOINT}")

  def store_blob
    if file_exists?
      raise "File with ID #{@blob_params[:id]} already exists."
    end

    request = build_request("PUT", "/#{@blob_params[:id]}", @blob_params[:data])
    response = send_request(request)

    if response.code == "200"
      create_blob_metadata
    else
      raise "Failed to upload to OSS: #{response.code} - #{response.message}"
    end
  end

  def retrieve_blob
    request = build_request("GET", "/#{@blob_params[:id]}")
    response = send_request(request)

    if response.code == "200"
      blob_metadata = BlobMetadata.find_by(blob_id: @blob_params[:id])

      {
        id: @blob_params[:id],
        data: response.body,
        size: blob_metadata.size,
        created_at: blob_metadata.created_at.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      }
    else
      raise "Failed to retrieve blob from cloud storage: #{response.code} - #{response.message}"
    end
  end

  private

  def file_exists?
    request = build_request("GET", "/#{@blob_params[:id]}")
    response = send_request(request)

    response.code == "200"
  end

  def build_request(method, path, body = nil)
    request = Net::HTTP.const_get(method.capitalize).new(path)

    if body
      request.body = body
      request["Content-Type"] = "text/plain"
      request["Content-Length"] = body.bytesize.to_s
    end

    request["Date"] = Time.now.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
    request["Authorization"] = sign_request(request)

    request
  end

  def send_request(request)
    http = Net::HTTP.new(URI.host, URI.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    http.request(request)
  end

  def sign_request(request)
    string_to_sign = "#{request.method}\n\n#{request["Content-Type"]}\n#{request["Date"]}\n/#{OSS_BUCKET}/#{@blob_params[:id]}"
    signature = OpenSSL::HMAC.digest("sha1", ACCESS_KEY_SECRET, string_to_sign)
    "OSS #{ACCESS_KEY_ID}:#{Base64.strict_encode64(signature)}"
  end

  def create_blob_metadata
    BlobMetadata.create!(blob_id: @blob_params[:id], owner_id: @current_user.id, size: @decoded_data.bytesize)
  end
end
