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

      blob_data = Blobs::Retrieve.new(blob_params, @current_user).call

      unless blob_data
        render(json: { code: 404, message: 'Data not found' })
        return
      end

      render(json: blob_data)
    rescue => e
      render(json: { code: 500, message: "An unexpected error occurred: #{e.message}" })
    end

    private

    def blob_params
      params.permit(:id, :data)
    end
  end
end