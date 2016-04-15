#!/usr/bin/env ruby
require 'pry' if ENV['DEBUG'] == 'true'
require 'colorize'
require_relative 'backup'
require_relative 'backup_mongodb'

if ARGV.empty?
  STDERR.puts "Error. Require a directory to save the backups"
  exit 1
end

require 'yaml'
config_path = File.expand_path "save_data.yml", File.dirname(File.absolute_path(__FILE__))
config = YAML.load_file(config_path)
# Mongodb saves
backup_dir = File.absolute_path(ARGV[0])
config["mongodb"].each do |data|
  puts "Save MongoDB #{data['name']}".yellow
  begin
    b = Backup::MongoDB.new(backup_dir: backup_dir, name: data['name'], domain: data['domain'], port: data['port'], database: data['database'], user: data['user'], password: data['password'])
    execute = b.execute
    puts (execute ? "Done #{execute}".green : "Error #{execute}".red)
  rescue => e
    puts e.message.to_s.red
  end
end
