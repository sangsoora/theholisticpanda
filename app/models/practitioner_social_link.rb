class PractitionerSocialLink < ApplicationRecord
  belongs_to :practitioner

  $media_types = ['Facebook', 'Instagram', 'Twitter', 'LinkedIn', 'YouTube', 'Other']
end
