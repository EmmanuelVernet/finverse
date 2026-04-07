# ForestAdminRails.configure do |config|
#   config.auth_secret = '4f580f25423c5507438d9ca3b61fbdb9e0780a73'
#   config.env_secret = '76087e73569bf631fe0e3f1da292292c93a1be139f22c99107ce18a4a5ad642a'
#   config.is_production = false
# end
ForestAdminRails.configure do |config|
  config.auth_secret = ENV['FOREST_AUTH_SECRET']
  config.env_secret  = ENV['FOREST_ENV_SECRET']
  config.is_production = true
end
