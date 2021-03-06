module CoreExtensions
  module ActiveStorage
    module Headers
      extend ActiveSupport::Concern

      private

        def set_headers(blob)
          # Hard coded this to 365, simply because thats what I want tbh
          expires_in 365.days, public: true

          response.headers["Content-Type"] = blob.content_type
          # Commented this out because in Rails 5.2.3 this isn't a thing
          # response.headers["Content-Disposition"] = ActionDispatch::Http::ContentDisposition.format(
          #   disposition: params[:disposition] || "inline",
          #   filename: blob.filename.sanitized
          # )
        end
    end
  end
end
