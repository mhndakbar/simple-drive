module V1
  class BlobsController < ApplicationController
    skip_before_action :verify_authenticity_token
    include TokenAuthentication


    def create
      if blob_params[:data].blank? || blob_params[:id].blank?
        render(json: {code: 400, message: 'Missing id or data'})
        return
      end

      Blobs::Create.new(blob_params, @current_user).call

      render(json: { code: 200, message: 'Data uploaded successfully' })
    rescue ActiveRecord::RecordNotUnique => e
      render(json: { code: 400, message: "#{e.message}" })
    rescue => e
      render(json: { code: 500, message: "An unexpected error occurred: #{e.message}" })
    end

    def show
      if blob_params[:id].blank?
        render(json: {code: 400, message: 'Missing id'})
        return
      end

      blob = Blob.find_by(id: blob_params[:id].to_s)

      unless blob
        render(json: { code: 404, message: 'Blob not found' })
        return
      end

      blob_metadata = BlobMetadata.find_by(blob_id: blob.id)

      render(json: {
        id: blob.id,
        data: blob.data,
        size: blob_metadata.size,
        created_at: blob.created_at.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
      })
    end

    private

    def blob_params
      params.permit(:id, :data)
    end
  end
end