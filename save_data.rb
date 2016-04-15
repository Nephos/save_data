#!/usr/bin/env ruby
require 'colorize'
require 'yaml'
require_relative 'Arguments'
require_relative 'Backup'
require_relative 'Backup/MongoDB'

begin
  opts = Arguments.instance.parse
  config = YAML.load_file($config_path)
  backup_dir = $backup_dir_path

  config.each do |list_name, list|
    list.each do |data|
      puts "Save #{list_name} `#{data['name']}`".yellow
      b = Backup.const_get(list_name).new(backup_dir: backup_dir, name: data['name'], domain: data['domain'], port: data['port'], database: data['database'], user: data['user'], password: data['password'])
      begin
        execute = b.execute
        puts (execute ? "Done `#{execute}`".green : "Error `#{execute}`".red)
      rescue => e
        puts e.message.to_s.red
      end
    end
  end
rescue => err
  puts err.message.to_s.red
  exit 1
end
