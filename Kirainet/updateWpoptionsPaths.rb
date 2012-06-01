# http://bugs.mysql.com/bug.php?id=61699 // https://github.com/brianmario/mysql2/issues/257
# export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH


# updateWpoptionsPaths.rb
#
# @kirai
#
# Description: updates site_url and home on wp_options table (Tested until Wp 3.3.1
#              It can be used with more than wordpress database at the same time
#
#
# Sample settings.yaml: 
#  sites:
#    - host: localhost
#      username: 
#      password: 
#      database: 
#      localurl: http://kirainet.localhost
#    - host: localhost
#      username: 
#      password: 
#      database: 
#      localurl: http://kirainet.localhost/fotografia
#    - host: localhost
#      username: 
#      password: 
#      database: 
#      localurl: http://kirainet.locahost/english
#

require 'mysql2'
require 'yaml'
p ARGV.inspect
if ARGV[0]
  settingsFile = ARGV[0]
else
  puts "You have to provide a YAML file as the first parameter"
  exit
end

begin
  settings = YAML::load_file(settingsFile)
rescue Exception => e
  puts "Could not parse YAML: #{e.message}"
  exit
end

begin

  settings['sites'].each do |site|
    client = Mysql2::Client.new(:host     => site["host"],
                                :username => site["username"],
                                :password => site["password"],
                                :database => site["database"])

    client.query("UPDATE `wp_options` SET `option_value` = '#{site["localurl"]}' WHERE `option_id` = '1'")
    client.query("UPDATE `wp_options` SET `option_value` = '#{site["localurl"]}' WHERE `option_id` = '39'")
  end

rescue Mysql::Error => e
  puts e.errno
  puts e.error  
end

puts 'Finished updating wp_options on the databases specified at settings.yaml'
