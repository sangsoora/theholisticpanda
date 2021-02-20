class BackgroundCheckController < ApplicationController
  skip_before_action :verify_authenticity_token
  def modo_webhooks
    raise
    if params["event"] == 'file.completed'
      file_id = params["fileId"]
      practitioner = Practitioner.find_by(background_check_id: file_id)
      practitioner.update(background_check_status: 'completed')
    end
  end
end
