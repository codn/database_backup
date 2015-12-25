require 'dropbox-api'
require 'date'

#############################
# Configuring for your server
#############################
# This section is for making sure your dropbox is configured correctly.
backup_file = "#{DateTime.now}.pg_dump.tar" # name of the created backup file
backup_file_path = "/tmp/#{backup_file}"
db_to_backup = "app_production" # name of the database to backup
db_user = "rails" # User to access database
db_pass = "db_pass" # password of the user to access database

# Create dropbox app at https://www.dropbox.com/developers/apps/create
# Choose dropbox-api
# Choose app-folder
Dropbox::API::Config.app_key    = 'dropbox_app_key'
Dropbox::API::Config.app_secret = 'dropbox_app_secret'
Dropbox::API::Config.mode       = 'sandbox'
# See https://github.com/futuresimple/dropbox-api#rake-based-authorization for help generating your client
client = Dropbox::API::Client.new(:token  => 'token', :secret => 'secret')

# Dump the database
system(
  "PGPASSWORD=\"#{db_pass}\" " +
  "pg_dump " +
  "-U #{db_user} " + # user
  "-F t " + # tar
  "-a " + # data only
  "-h localhost " + # host
  "-p 5432 " + # port
  db_to_backup +
  " > #{backup_file}"
)

# Upload to dropbox
client.chunked_upload "#{db_to_backup}/#{backup_file}", File.open(backup_file_path)
