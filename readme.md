# Postgres Database Backup in Dropbox

This is a script to backup your database in dropbox every given time
(configured in a crontab). It connects to your database creates a dump and
upload it to your personal dropbox.

Tested in digital ocean droplets.

# Dependencies
* Ruby
* Crontab

Run
```
gem install dropbox-api
rvm cron setup
git clone https://github.com/codn/dropbox-database-backup.git ~/dropbox-database-backup
```

Create a dropbox app (if you dont have one yet)

Update variables
```
nano ~/dropbox-database-backup/backup.rb
```
* `db_to_backup`
* `db_user`
* `db_pass`
* `Dropbox::API::Config.app_key`
* `Dropbox::API::Config.app_secret`
* `client`

Run:

```
crontab -e
```

Append your crontab

***Make sure script path is correct***

```
# run every day at 2:30 am
30 2 * * * /home/rails/dropbox-database-backup/backup.rb >> /home/rails/dropbox-database-backup/backup-cron.log 2>&1

# run every minute (to test it works)
* * * * * /home/rails/dropbox-database-backup/backup.rb >> /home/rails/dropbox-database-backup/backup-cron.log 2>&1
```

Youre database is now being backed up in your dropbox. :tada:

Issues and pull requests to improve documentation or code are welcome.
