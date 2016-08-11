require 'dropbox-api'
require 'date'

#############################
# Configuring your dropbox app
## create app: https://www.dropbox.com/developers/apps/create
## * Choose dropbox-api
## * Choose app-folder
# See https://github.com/futuresimple/dropbox-api#rake-based-authorization
# for help generating your client token and secret.
#############################
Dropbox::API::Config.app_key    = 'dropbox_app_key'
Dropbox::API::Config.app_secret = 'dropbox_app_secret'
Dropbox::API::Config.mode       = 'sandbox'
client = Dropbox::API::Client.new(token: 'token', secret: 'secret')

##########
# Database
##########
db_user = "rails" # User to access database
db_pass = "db_pass" # password of the user to access database
db_to_backup = "app_production" # name of the database to backup

##########
# Misc
##########
backup_name = "#{DateTime.now}.pg_dump.tar" # name of the created backup file
backup_file_path = "/tmp/#{backup_name}"
backup_folder = db_to_backup

#############################
# Script
#############################
system(
  "PGPASSWORD=\"#{db_pass}\" " +
  "pg_dump " +
  "-U #{db_user} " + # user
  "-F t " +          # tar
  "-a " +            # data only
  "-h localhost " +  # host
  "-p 5432 " +       # port
  db_to_backup +
  " > #{backup_file_path}"
)

# Upload to dropbox
client.chunked_upload "#{backup_folder}/#{backup_name}", File.open(backup_file_path)
