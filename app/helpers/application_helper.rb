module ApplicationHelper
  def cdn_for(file)
    file.key
  end
  # active_storage_item could be a blob or variant object
  # def proxy_url(active_storage_item, options = {})
  #   options.merge!(host: ENV['CDN_URL']) if ENV['CDN_URL'].present?

  #   # proxy: 'true' allows you to stil have the original functionality while
  #   # being able to proxy through a CDN. You've got to ensure that your CDN
  #   # forwards this param otherwise active storage will always do the default
  #   # behavior which is a redirect to the service.
  #   # This is also meant to be intended for items that are always going to be
  #   # public. If you have files that might be private then there's no point in
  #   # caching it with cloudfront.
  #   # See lib/core_extensions/active_storage/blob/downloader and
  #   # lib/core_extensions/active_storage/representation/downloader
  #   polymorphic_url(active_storage_item, options.merge(proxy: 'true'))
  # end
end
