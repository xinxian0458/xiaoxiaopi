RAILS_ENV=production rake db:reset
RAILS_ENV=production rake log:clear
RAILS_ENV=production rake dodai:softwares:load_all
./script/stop-servers production
./script/start-servers production
