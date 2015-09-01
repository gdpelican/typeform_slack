require 'json'
require 'curb'
require 'cgi'
require 'yaml'
require 'ostruct'

def config
  @config ||= OpenStruct.new YAML.load_file 'config.yml'
end

def invitable_emails
  `touch #{config.local_invited_list}`
  invited_emails = File.foreach(config.local_invited_list)

  json = JSON.parse Curl.get(formtype_api_url(invited_emails.count)).body_str
  json['responses'].map do |response|
    email = response['answers'][config.formtype_email_field]
    email unless invited_emails.include?(email)
  end.reject(&:empty?)
end

def invite_to_slack(email)
  Curl.post(slack_api_url, slack_payload(email))
end

def formtype_api_url(offset)
  "https://api.typeform.com/v0/form/#{config.formtype_form_uid}?key=#{config.formtype_api_key}&completed=true&offset=#{offset}"
end

def slack_api_url
  "https://#{config.slack_domain}.slack.com/api/users.admin.invite?t=#{Time.now.to_i}"
end

def slack_payload(email)
  {
    email: email,
    channels: config.slack_channels,
    token: CGI.escape(config.slack_api_key),
    set_active: CGI.escape('true'),
    _attempts: 1
  }
end

invitable_emails.each do |email|
  if JSON.parse(invite_to_slack(email).body)['ok']
    puts "Invited #{email}"
    File.open(config.local_invited_list, 'a') { |file| file.puts "#{email}\n" }
  end
end
