# Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), 'lib/core_extensions')) + "/**/*.rb"].each do |file|
#   require file
# end
# ActiveStorage::RepresentationsController.prepend CoreExtensions::ActiveStorage::Representation::Downloader
# ActiveStorage::BlobsController.prepend CoreExtensions::ActiveStorage::Blob::Downloader
