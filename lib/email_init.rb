require 'pony'
Pony.options = {
  :to      => ENV['ADMIN_EMAIL'],
  :from    => "Wikindle App <#{ENV['APP_EMAIL'] || ENV['ADMIN_EMAIL']}>",
  :via     => :smtp,
  :via_options => {
    :address        => "smtp.sendgrid.net",
    :port           => "25",
    :authentication => "plain",
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => ENV['SENDGRID_DOMAIN']
  }
}


