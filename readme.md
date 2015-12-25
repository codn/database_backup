# Postgres Database Backup

This is a script to backup your database in dropbox every given time
(configured in a crontab). It connects to your database creates a dump and
upload it to your personal dropbox.

Tested in digital ocean droplets.

# Setup

Before starting:
* Make sure your user can execute ruby.
* gem install dropbox-api
* run `rvm cron setup` in order to execute ruby in crontabs
* `git clone https://github.com/codn/dropbox-database-backup.git ~/dropbox-database-backup`
* Create a dropbox app (if you dont have one yet)
* Update variables `db_user`, `db_pass`, `Dropbox::API::Config.app_key`, `Dropbox::API::Config.app_secret` and `client` in `~/dropbox-database-backup/backup.rb`

Run:

```
crontab -e
```

Append your crontab

```
# run every day at 2:30 am
30 2 * * * /home/rails/dropbox-database-backup/backup.rb >> /home/rails/dropbox-database-backup/backup-cron.log 2>&1

# run every minute (to test it works)
* * * * * /home/rails/dropbox-database-backup/backup.rb >> /home/rails/dropbox-database-backup/backup-cron.log 2>&1
```

Youre database is now being backed up in your dropbox. :tada:
