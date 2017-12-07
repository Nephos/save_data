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

  failures = []

  # Execute each backup
  config.each do |list_name, backup_list|
    backup_list.each do |backup_config|
      puts "Save #{list_name} `#{backup_config['name']}`".yellow
      current_backup = Backup.const_get(list_name).new(backup_config["name"], backup_dir, backup_config)
      begin
        execute = current_backup.execute
        puts (execute ? "Done `#{execute}`".green : "Error `#{execute}`".red)
      rescue => err
        puts err.message.to_s.red
        failures << err.message
      end
    end
  end

  # Send a local mail
  if $mail
    total_saves = config.reduce(0) { |l, list| l + list.reduce(0) { |l, data| l + data.size } }
    mail = "Subject: " + if failures.empty?
      "Backup OK #{Date.today}"
    else
      "Backup FAILED #{Date.today} (#{failures.size}/#{total_saves})\n\n#{failures.join("\n\n")}"
    end
    mail.gsub!('"', '\"')
    puts `echo -n "#{mail}" | sendmail #{ENV["USER"]}`
  end

rescue => err
  if ENV['DEBUG'] == 'true'
    raise err
  else
    puts err.message.to_s.red
    exit 1
  end
end
