class Practitioner < ApplicationRecord
  belongs_to :user
  has_one_attached :banner_image
  has_many :practitioner_languages, dependent: :destroy
  has_many :practitioner_specialties, dependent: :destroy
  has_many :working_hours, dependent: :destroy
  has_many :services, through: :practitioner_specialties, dependent: :destroy
  has_many :sessions, through: :services
  has_many :reviews, through: :sessions
  has_many :languages, through: :practitioner_languages
  has_many :specialties, through: :practitioner_specialties
  has_many :health_goals, through: :specialties
  has_many :practitioner_social_links, dependent: :destroy
  has_many :practitioner_certifications, dependent: :destroy
  has_many :practitioner_memberships, dependent: :destroy
  has_many :favorite_practitioners, dependent: :destroy
  has_many :favorite_users, through: :favorite_practitioners, source: :user
  validates_uniqueness_of :user
  validates :bio, length: {maximum: 1000}
  validates :approach, length: {maximum: 1000}
  scope :filter_by_specialty, ->(specialties) { joins(:specialties).where(specialties: { id: specialties }) }
  scope :filter_by_health_goal, ->(health_goals) { joins(:health_goals).where(health_goals: { id: health_goals }) }
  scope :filter_by_language, ->(languages) { joins(:languages).where(languages: { id: languages }) }
  scope :filter_by_service_type, ->(service_type) { where service_type: service_type }
  monetize :amount_cents, allow_nil: true

  $specialties = Specialty.all.sort_by(&:name)
  $health_goals = HealthGoal.all.sort_by(&:name)
  $languages = Language.includes(:practitioner_languages).where.not(practitioner_languages: { id: nil }).sort_by(&:name)
  $service_types = ['Virtual only', 'In-person only', 'Both available']

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def rating_avg
    (reviews.sum(:rating).to_f / reviews.size).round(2)
  end

  def converted_working_hours(user)
    user_time_offset = Time.current.in_time_zone(user.timezone).utc_offset
    practitioner_time_offset = Time.current.in_time_zone(timezone).utc_offset
    time_diff = user_time_offset - practitioner_time_offset
    converted_working_hours = {}
    (0..6).to_a.each { |num| converted_working_hours[num] = [] }
    working_hours.each do |workingday|
      converted_open_hour = workingday.opens + time_diff unless workingday.opens == nil
      unless workingday.closes == nil
        if workingday.closes.strftime('%H:%M') == '00:00'
          converted_close_hour = workingday.closes + 1.days + time_diff
        else
          converted_close_hour = workingday.closes + time_diff
        end
      end
      if converted_open_hour && converted_close_hour
        if workingday.day == 1 || workingday.day == 2 || workingday.day == 3 || workingday.day == 4 || workingday.day == 5
          if converted_open_hour.strftime('%d') == '31' && converted_close_hour.strftime('%d') == '31'
            converted_working_hours[workingday.day - 1] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '31' && converted_close_hour.strftime('%d') == '01'
            converted_working_hours[workingday.day - 1] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': '24:00' }
            if converted_close_hour.strftime('%H:%M') != '00:00'
              converted_working_hours[workingday.day] << { 'starts': '00:00', 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
            end
          elsif converted_open_hour.strftime('%d') == '01' && converted_close_hour.strftime('%d') == '01'
            converted_working_hours[workingday.day] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '01' && converted_close_hour.strftime('%d') == '02'
            converted_working_hours[workingday.day] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': '24:00' }
            converted_working_hours[workingday.day + 1] << { 'starts': '00:00', 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '02' && converted_close_hour.strftime('%d') == '02'
            converted_working_hours[workingday.day + 1] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          end
        elsif workingday.day == 0
          if converted_open_hour.strftime('%d') == '31' && converted_close_hour.strftime('%d') == '31'
            converted_working_hours[6] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '31' && converted_close_hour.strftime('%d') == '01'
            converted_working_hours[6] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': '24:00' }
            converted_working_hours[workingday.day] << { 'starts': '00:00', 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '01' && converted_close_hour.strftime('%d') == '01'
            converted_working_hours[workingday.day] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '01' && converted_close_hour.strftime('%d') == '02'
            converted_working_hours[workingday.day] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': '24:00' }
            converted_working_hours[workingday.day + 1] << { 'starts': '00:00', 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '02' && converted_close_hour.strftime('%d') == '02'
            converted_working_hours[workingday.day + 1] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          end
        elsif workingday.day == 6
          if converted_open_hour.strftime('%d') == '31' && converted_close_hour.strftime('%d') == '31'
            converted_working_hours[workingday.day - 1] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '31' && converted_close_hour.strftime('%d') == '01'
            converted_working_hours[workingday.day - 1] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': '24:00' }
            converted_working_hours[workingday.day] << { 'starts': '00:00', 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '01' && converted_close_hour.strftime('%d') == '01'
            converted_working_hours[workingday.day] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '01' && converted_close_hour.strftime('%d') == '02'
            converted_working_hours[workingday.day] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': '24:00' }
            converted_working_hours[0] << { 'starts': "00:00", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          elsif converted_open_hour.strftime('%d') == '02' && converted_close_hour.strftime('%d') == '02'
            converted_working_hours[0] << { 'starts': "#{converted_open_hour.strftime('%H:%M')}", 'ends': "#{converted_close_hour.strftime('%H:%M')}" }
          end
        end
      end
    end
    converted_working_hours
  end

  def timezone_choice
    timezone = [
      ['Etc/GMT+12', '(GMT-12:00) International Date Line West'],
      ['Pacific/Midway', '(GMT-11:00) Midway Island, Samoa'],
      ['Pacific/Honolulu', '(GMT-10:00) Hawaii'],
      ['US/Alaska', '(GMT-09:00) Alaska'],
      ['America/Los_Angeles', '(GMT-08:00) Pacific Time (US & Canada)'],
      ['America/Tijuana', '(GMT-08:00) Tijuana, Baja California'],
      ['US/Arizona', '(GMT-07:00) Arizona'],
      ['America/Chihuahua', '(GMT-07:00) Chihuahua, La Paz, Mazatlan'],
      ['US/Mountain', '(GMT-07:00) Mountain Time (US & Canada)'],
      ['America/Managua', '(GMT-06:00) Central America'],
      ['US/Central', '(GMT-06:00) Central Time (US & Canada)'],
      ['America/Mexico_City', '(GMT-06:00) Guadalajara, Mexico City, Monterrey'],
      ['Canada/Saskatchewan', '(GMT-06:00) Saskatchewan'],
      ['America/Bogota', '(GMT-05:00) Bogota, Lima, Quito, Rio Branco'],
      ['US/Eastern', '(GMT-05:00) Eastern Time (US & Canada)'],
      ['US/East-Indiana', '(GMT-05:00) Indiana (East)'],
      ['Canada/Atlantic', '(GMT-04:00) Atlantic Time (Canada)'],
      ['America/Caracas', '(GMT-04:00) Caracas, La Paz'],
      ['America/Manaus', '(GMT-04:00) Manaus'],
      ['America/Santiago', '(GMT-04:00) Santiago'],
      ['Canada/Newfoundland', '(GMT-03:30) Newfoundland'],
      ['America/Sao_Paulo', '(GMT-03:00) Brasilia'],
      ['America/Argentina/Buenos_Aires', '(GMT-03:00) Buenos Aires, Georgetown'],
      ['America/Godthab', '(GMT-03:00) Greenland'],
      ['America/Montevideo', '(GMT-03:00) Montevideo'],
      ['America/Noronha', '(GMT-02:00) Mid-Atlantic'],
      ['Atlantic/Cape_Verde', '(GMT-01:00) Cape Verde Is.'],
      ['Atlantic/Azores', '(GMT-01:00) Azores'],
      ['Africa/Casablanca', '(GMT+00:00) Casablanca, Monrovia, Reykjavik'],
      ['Etc/Greenwich', '(GMT+00:00) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London'],
      ['Europe/Amsterdam', '(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'],
      ['Europe/Belgrade', '(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague'],
      ['Europe/Brussels', '(GMT+01:00) Brussels, Copenhagen, Madrid, Paris'],
      ['Europe/Sarajevo', '(GMT+01:00) Sarajevo, Skopje, Warsaw, Zagreb'],
      ['Africa/Lagos', '(GMT+01:00) West Central Africa'],
      ['Asia/Amman', '(GMT+02:00) Amman'],
      ['Europe/Athens', '(GMT+02:00) Athens, Bucharest, Istanbul'],
      ['Asia/Beirut', '(GMT+02:00) Beirut'],
      ['Africa/Cairo', '(GMT+02:00) Cairo'],
      ['Africa/Harare', '(GMT+02:00) Harare, Pretoria'],
      ['Europe/Helsinki', '(GMT+02:00) Helsinki, Kyiv, Riga, Sofia, Tallinn, Vilnius'],
      ['Asia/Jerusalem', '(GMT+02:00) Jerusalem'],
      ['Europe/Minsk', '(GMT+02:00) Minsk'],
      ['Africa/Windhoek', '(GMT+02:00) Windhoek'],
      ['Asia/Kuwait', '(GMT+03:00) Kuwait, Riyadh, Baghdad'],
      ['Europe/Moscow', '(GMT+03:00) Moscow, St. Petersburg, Volgograd'],
      ['Africa/Nairobi', '(GMT+03:00) Nairobi'],
      ['Asia/Tbilisi', '(GMT+03:00) Tbilisi'],
      ['Asia/Tehran', '(GMT+03:30) Tehran'],
      ['Asia/Muscat', '(GMT+04:00) Abu Dhabi, Muscat'],
      ['Asia/Baku', '(GMT+04:00) Baku'],
      ['Asia/Yerevan', '(GMT+04:00) Yerevan'],
      ['Asia/Kabul', '(GMT+04:30) Kabul'],
      ['Asia/Yekaterinburg', '(GMT+05:00) Yekaterinburg'],
      ['Asia/Karachi', '(GMT+05:00) Islamabad, Karachi, Tashkent'],
      ['Asia/Calcutta', '(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi'],
      ['Asia/Calcutta', '(GMT+05:30) Sri Jayawardenapura'],
      ['Asia/Katmandu', '(GMT+05:45) Kathmandu'],
      ['Asia/Almaty', '(GMT+06:00) Almaty, Novosibirsk'],
      ['Asia/Dhaka', '(GMT+06:00) Astana, Dhaka'],
      ['Asia/Rangoon', '(GMT+06:30) Yangon (Rangoon)'],
      ['Asia/Bangkok', '(GMT+07:00) Bangkok, Hanoi, Jakarta'],
      ['Asia/Krasnoyarsk', '(GMT+07:00) Krasnoyarsk'],
      ['Asia/Hong_Kong', '(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi'],
      ['Asia/Kuala_Lumpur', '(GMT+08:00) Kuala Lumpur, Singapore'],
      ['Asia/Irkutsk', '(GMT+08:00) Irkutsk, Ulaan Bataar'],
      ['Australia/Perth', '(GMT+08:00) Perth'],
      ['Asia/Taipei', '(GMT+08:00) Taipei'],
      ['Asia/Tokyo', '(GMT+09:00) Osaka, Sapporo, Tokyo'],
      ['Asia/Seoul', '(GMT+09:00) Seoul'],
      ['Asia/Yakutsk', '(GMT+09:00) Yakutsk'],
      ['Australia/Adelaide', '(GMT+09:30) Adelaide'],
      ['Australia/Darwin', '(GMT+09:30) Darwin'],
      ['Australia/Brisbane', '(GMT+10:00) Brisbane'],
      ['Australia/Canberra', '(GMT+10:00) Canberra, Melbourne, Sydney'],
      ['Australia/Hobart', '(GMT+10:00) Hobart'],
      ['Pacific/Guam', '(GMT+10:00) Guam, Port Moresby'],
      ['Asia/Vladivostok', '(GMT+10:00) Vladivostok'],
      ['Asia/Magadan', '(GMT+11:00) Magadan, Solomon Is., New Caledonia'],
      ['Pacific/Auckland', '(GMT+12:00) Auckland, Wellington'],
      ['Pacific/Fiji', '(GMT+12:00) Fiji, Kamchatka, Marshall Is.'],
      ['Pacific/Tongatapu', '(GMT+13:00) Nuku\'alofa']
    ]
    timezone
  end

  def self.checked_practitioners
    where(payment_status: 'paid', background_check_status: 'completed', agreement_status: 'completed', agreement_consent: true, background_check_consent: true)
  end

  def checked?
    (payment_status == 'paid') && (background_check_status == 'completed') && (agreement_status == 'completed') && agreement_consent && background_check_consent
  end
end
