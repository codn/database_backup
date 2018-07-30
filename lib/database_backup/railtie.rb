module DatabaseBackup
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/database_backup.rake"
    end
  end
end
