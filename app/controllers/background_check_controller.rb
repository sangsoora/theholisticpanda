class BackgroundCheckController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!
  def modo_webhooks
    if params['event'] == 'file.completed'
      file_id = params['fileId']
      if Practitioner.find_by(background_check_id: file_id)
        practitioner = Practitioner.find_by(background_check_id: file_id)
        practitioner.update(background_check_status: 'completed')
      end
    end
  end
end
