#!/usr/bin/env ruby
module SaveData
end

require 'colorize'
require 'yaml'
require_relative 'arguments'
require_relative '../lib/backup/core'
require_relative '../lib/backup/mongodb'
require_relative '../lib/backup/ssh'
require_relative '../lib/backup/git'
require_relative '../lib/backup/postgresql'

module SaveData::Main
  extend self

  def start(opts, config)
    failures = []

    # Execute each backup
    config.each do |list_name, backup_list|
      backup_list.each do |backup_config|
        puts "Save #{list_name} `#{backup_config['name']}`".yellow
        current_backup = Backup.const_get(list_name).new(backup_config["name"], $backup_dir_path, backup_config)
        begin
          execute = current_backup.execute
          puts(execute ? "Done `#{execute}`".green : "Error `#{execute}`".red)
        rescue => err
          puts err.message.to_s.red
          failures << err.message
        end
      end
    end

    send_mail(failures)
  end

  def send_mail(failures)
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
  end
end


opts = SaveData::Arguments.instance.parse
config = YAML.load_file($config_path)

begin
  SaveData::Main.start(opts, config)
rescue => err
  if ENV['DEBUG'] == 'true'
    raise err
  else
    puts err.message.to_s.red
    exit 1
  end
end
