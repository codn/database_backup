# Postgres Database Backup in Dropbox

This is a script to backup your database in dropbox every given time
(configured in a crontab). It connects to your database creates a dump and
upload it to your personal dropbox.

Tested in digital ocean droplets.

# Dependencies
* Ruby
* Crontab

# Quick installation (Recommended)

Backups are installed by running one of the following commands in your terminal. You can install this via the command-line with either curl or wget.

via curl
```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/codn/dropbox-database-backup/master/install.sh)"
```
via wget
```
$ sh -c "$(wget https://raw.githubusercontent.com/codn/dropbox-database-backup/master/install.sh -O -)"
```

# Manual installation
Run
```
gem install dropbox-sdk-v2
rvm cron setup
git clone https://github.com/codn/dropbox-database-backup.git ~/dropbox-database-backup
```

[Create a dropbox app](https://www.dropbox.com/developers/apps/create) (if you dont have one yet):
* Choose dropbox-api
* Choose app-folder
* Allow oauth redirect to http://localhost

Generate your ACCESS TOKEN entering the next url (replacing `YOUR_APP_KEY` with the dropbox app key):

```
https://www.dropbox.com/oauth2/authorize?client_id=YOUR_APP_KEY&response_type=token&redirect_uri=http://localhost
# You're going to be redirect to http://localhost/access_token=COMPLETE-ACCESS-TOKEN&token-type=bearer
# Copy your COMPLETE-ACCESS-TOKEN
```

Run:

```
crontab -e
```

Append your crontab

***Make sure script path is correct***

```
# run every day at 2:30 am
30 2 * * * ruby /home/deploy/dropbox-database-backup/backup.rb >> /home/deploy/dropbox-database-backup/backup-cron.log 2>&1

# run every minute (to test it works)
* * * * * ruby /home/deploy/dropbox-database-backup/backup.rb >> /home/deploy/dropbox-database-backup/backup-cron.log 2>&1
```

Rbenv users: user your user's ruby to run the command. No other setup required: `/home/deploy/.rbenv/shims/ruby /home/deploy/dropbox-database-backup/backup.rb >> /home/deploy/dropbox-database-backup/backup-cron.log 2>&1`

# Usage

Update variables
```
nano ~/dropbox-database-backup/backup.rb
```
* `db_to_backup`
* `db_user`
* `db_pass`
* `acess_token`

# Recovering database

Youre database is now being backed up in your dropbox and can be restored with:
***Your database (and schemas) must exist with their tables truncated***
```
# Whatever the database and your backup names are.
$ pg_restore -C -d database_name 2016-02-24T05_12_01-05_00.pg_dump.tar
```

Issues and pull requests to improve documentation or code are welcome.
