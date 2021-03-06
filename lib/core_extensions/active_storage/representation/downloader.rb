# module CoreExtensions
#   module ActiveStorage
#     module Representation
#       module Downloader
#         include CoreExtensions::ActiveStorage::Headers

#         def show
#           return super unless params[:proxy] == 'true'
#           set_headers(@blob)
#           variant = @blob.representation(params[:variation_key]).processed
#           @blob.service.download(variant.key) do |chunk|
#             response.stream.write(chunk)
#           end
#         ensure
#           response.stream.close
#         end
#       end
#     end
#   end
# end
