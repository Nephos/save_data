#!/usr/bin/env ruby
require 'colorize'
require 'yaml'
require_relative 'arguments'
require_relative 'backup/core'
require_relative 'backup/mongodb'
require_relative 'backup/ssh'
require_relative 'backup/git'
require_relative 'backup/postgresql'

begin
  opts = Arguments.instance.parse
  config = YAML.load_file($config_path)
  backup_dir = $backup_dir_path

  config.each do |list_name, list|
    list.each do |data|
      puts "Save #{list_name} `#{data['name']}`".yellow
      b = Backup.const_get(list_name).new(data["name"], backup_dir, data)
      begin
        execute = b.execute
        puts (execute ? "Done `#{execute}`".green : "Error `#{execute}`".red)
      rescue => e
        puts e.message.to_s.red
      end
    end
  end
rescue => err
  if ENV['DEBUG'] == 'true'
    raise err
  else
    puts err.message.to_s.red
    exit 1
  end
end
