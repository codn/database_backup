main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if [ ! command "rvm" &> /dev/null ] && [  command 'rbenv' &> /dev/null ]; then
    echo 'nor rbenv or rvm found please install one!'
    exit 1
  fi

  printf "${BLUE}Installing gems dependencies...${NORMAL}\n"
  gem install dropbox-sdk-v2 || {
    echo "Error installing dropbox-sdk-v2 gem"
    exit 1
  }

  printf "${BLUE}Cloning Dropbox database backup...${NORMAL}\n"
  hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }

  env git clone --depth=1 https://github.com/codn/dropbox-database-backup.git ~/dropbox-database-backup || {
    echo "Error: git clone of drobbox-database-backup repo failed"
    exit 1
  }

  printf "${BLUE}Setting up the crontab...${NORMAL}\n"
  hash crontab >/dev/null 2>&1 || {
    echo "Error: crontab is not installed"
    exit 1
  }

  if [[ command "rvm" &> /dev/null ]]; then
    rvm cron setup
    RVM_CMD="30 2 * * * ruby /home/deploy/dropbox-database-backup/backup.rb >> /home/deploy/dropbox-database-backup/backup-cron.log 2>&1"
    (crontab -u `whoami` -l; echo "$RVM_CMD") | crontab -u `whoami` - || {
      echo "Errror installing crontab with rvm"
      exit 1
    }
  elif [[ command "rbenv" &> /dev/null ]]; then
    RBENV_CMD="30 2 * * * /home/`whoami`/.rbenv/shims/ruby /home/`whoami`/dropbox-database-backup/backup.rb >> /home/`whoami`/dropbox-database-backup/backup-cron.log 2>&1"
    (crontab -u `whoami` -l; echo "$RBENV_CMD") | crontab -u `whoami` - || {
      echo "Errror installing crontab with rbenv"
      exit 1
    }
  fi

  printf "${RED}"

  echo "   (          (            (  (               )  (           )      "
  echo "   )\         )\ )         )\))(   '   (   ( /(  )\    )  ( /(      "
  echo " (((_)   (   (()/(  (     ((_)()\ )   ))\  )\())((_)( /(  )\()) (   "
  echo " )\___   )\   ((_)) )\ )  _(())\_)() /((_)((_)\  _  )(_))((_)\  )\  "
  echo "((/ __| ((_)  _| | _(_/(  \ \((_)/ /(_))  | |(_)| |((_)_ | |(_)((_) "
  echo " | (__ / _ \/ _\` || ' \))  \ \/\/ / / -_) | '_ \| |/ _\` || '_ \(_-< "
  echo "  \___|\___/\__,_||_||_|    \_/\_/  \___| |_.__/|_|\__,_||_.__//__/ "

  printf "${NORMAL}"
  echo ''
  echo 'Look over the docs at https://github.com/codn/dropbox-database-backup'
  echo ''
  echo 'You still need to configure your db enviroment in ~/dropbox-database-backup/backup.rb'
  echo ''
  echo 'p.s. Help and instrucions at the repo above'
  echo ''
}

main
