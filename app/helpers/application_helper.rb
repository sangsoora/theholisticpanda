module ApplicationHelper
  def cdn_for(file)
    "https://#{ENV['CDN_URL']}/#{file.key}"
  end
end
