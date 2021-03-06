module CoreExtensions
  module ActiveStorage
    module Blob
      module Downloader
        include CoreExtensions::ActiveStorage::Headers

        def show
          return super unless params[:proxy] == 'true'
          set_headers(@blob)
          @blob.download do |chunk|
            response.stream.write(chunk)
          end
        ensure
          response.stream.close
        end
      end
    end
  end
end
