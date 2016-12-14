require 'dropbox'

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

backup_name = "#{now.to_s.gsub(' ', '_')}.pg_dump.tar" # name of the created backup file
backup_file_path = "/tmp/#{backup_name}"
backup_folder = "/#{db_to_backup}"
oldest_backup_date = Time.new(now.year, now.month - 1, now.day, now.hour, now.min, now.sec) # More than a month old

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
