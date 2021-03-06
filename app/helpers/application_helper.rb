module ApplicationHelper
  def cdn_for(file)
    "#{ENV['CDN_URL']}/#{file.key}"
  end
end
