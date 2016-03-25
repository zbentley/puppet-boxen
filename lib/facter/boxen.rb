require "json"
require "boxen/config"

config      = Boxen::Config.load
facts       = {}
factsdir    = "#{config.homedir}/config/facts"
dot_boxen   = "#{ENV['HOME']}/.boxen"
user_config = "#{dot_boxen}/config.json"

facts["github_login"]  = config.login
facts["github_email"]  = config.email
facts["github_name"]   = config.name

facts["boxen_home"]    = config.homedir
facts["boxen_user"]    = config.user
facts["luser"]         = config.user # this is goin' away

Dir["#{config.homedir}/config/facts/*.json"].each do |file|
  facts.merge! JSON.parse File.read file
end

facts.each do |k, v|
  Facter.add(k) { has_weight(-1); setcode { v } }
end
