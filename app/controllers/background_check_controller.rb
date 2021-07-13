class BackgroundCheckController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[certn_webhooks modo_webhooks]
  skip_before_action :authenticate_user!, only: %i[certn_webhooks modo_webhooks]
  skip_after_action :verify_authorized, only: %i[certn_webhooks modo_webhooks]
  skip_after_action :verify_policy_scoped, only: %i[certn_webhooks modo_webhooks]
  def certn_webhooks
    if params["status"] == 'Returned' && params["result"] == 'CLEARED' && params["certn_score_value"] == 'PASS'
      file_id = params["application"]["id"]
      if Practitioner.find_by(background_check_id: file_id)
        practitioner = Practitioner.find_by(background_check_id: file_id)
        practitioner.update(background_check_status: 'completed')
      end
    end
  end
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
