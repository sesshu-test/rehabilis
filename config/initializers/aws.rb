Aws::Rails.add_action_mailer_delivery_method(
  :ses,
  credentials: Aws::Credentials.new(Rails.application.credentials.aws[:access_key_id], Rails.application.credentials.aws[:secret_access_key]),
  #credentials: Aws::Credentials.new('AKIA6EX5FTR47GTFADZA', 'yCD55YgOe3pIGcf4zEmlallO7BuGPVp2+c+k0t5Z'),
  region: 'us-west-1'
)