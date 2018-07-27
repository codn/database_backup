
namespace :database_backup do
  task backup: :environment do |t|
    config = ActiveRecord::Base.connection_config

    now = Time.now

    backup_name = "#{now.to_s.gsub(' ', '_')}.pg_dump" # name of the created backup file
    backup_file_path = "/tmp/#{backup_name}"
    backup_folder = "/#{config[:database]}"
    oldest_backup_date = (now.to_datetime << 1).to_time # More than a month old

    system(
      "PGPASSWORD=\"#{config[:password]}\" " +
      "pg_dump " +
      "-U #{config[:username]} " + # user
      "-Fc " +                     # Format=custom
      "-a " +                      # data only
      "-h localhost " +            # host
      "-p 5432 " +                 # port
      config[:database] +          # database to back up
      " > #{backup_file_path}"
    )

    print "Uploading #{backup_file_path} to #{backup_folder}/#{backup_name} (~#{(File.size(backup_file_path) / (1024 * 1024)).round(2)} MB)\n"

    # Upload to dropbox
    dropbox_access_token = 'user_access_token'
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
  end
end
