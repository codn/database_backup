require 'dropbox'
require 'date'

#############################
# Configuring your dropbox app
## create app: https://www.dropbox.com/developers/apps/create
## * Choose dropbox-api
## * Choose app-folder
## * Allow oauth redirect to http://localhost
#############################
# To generate access token enter this url with replacing YOUR_APP_KEY
#
# https://www.dropbox.com/oauth2/authorize?client_id=YOUR_APP_KEY&response_type=token&redirect_uri=http://localhost
# After you accept, you are going to be redirected to:
# http://localhost/access_token=COMPLETE-ACCESS-TOKEN&token-type=bearer
client = Dropbox::Client.new(COMPLETE_ACCESS_TOKEN)

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
backup_folder = "/#{db_to_backup}"

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
client.upload "#{backup_folder}/#{backup_name}", File.read(backup_file_path)
