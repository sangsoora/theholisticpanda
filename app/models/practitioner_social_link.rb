class PractitionerSocialLink < ApplicationRecord
  belongs_to :practitioner

  $media_types = ['Instagram', 'YouTube', 'TikTok', 'Facebook', 'Twitter', 'LinkedIn', 'Other']
end
