require 'dropbox'
require 'date'

##################
# Setup
##################
dropbox_access_token = 'user_access_token'
db_user = "rails" # User to access database
db_pass = "db_pass" # password of the user to access database
db_to_backup = "app_production" # name of the database to backup

##########
# Misc
##########
now = Time.now

backup_name = "#{now.to_s.gsub(' ', '_')}.pg_dump" # name of the created backup file
backup_file_path = "/tmp/#{backup_name}"
backup_folder = "/#{db_to_backup}"
oldest_backup_date = (now.to_datetime << 1).to_time # More than a month old

#############################
# Script
#############################
print "Backing up #{db_to_backup}\n"
system(
  "PGPASSWORD=\"#{db_pass}\" " +
  "pg_dump " +
  "-U #{db_user} " + # user
  "-Fc " +           # Format=custom
  "-a " +            # data only
  "-h localhost " +  # host
  "-p 5432 " +       # port
  db_to_backup +
  " > #{backup_file_path}"
)

print "Uploading #{backup_file_path} to #{backup_folder}/#{backup_name} (~#{(File.size(backup_file_path) / (1024 * 1024)).round(2)} MB)\n"
# Upload to dropbox
client = Dropbox::Client.new(dropbox_access_token)
client.upload "#{backup_folder}/#{backup_name}", File.read(backup_file_path)

#####################
# Delete old backups
#####################
files = client.list_folder backup_folder
files.each do |file|
  if file.server_modified < oldest_backup_date
    print "Detected #{file.path_lower} is older than permitted date, deleting...\n"
    client.delete file.path_lower
  end
end
