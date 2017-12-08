#!/usr/bin/env ruby

require 'optparse'
require 'singleton'

# ```
# SaveData::Arguments.instance.parse
# ```
class SaveData::Arguments
  include Singleton

  def parse
    OptionParser.new do |opt|
      opt.banner = "Usage: save_data <options>"

      $config_path = ENV["SAVE_DATA_CONFIG_PATH"] || File.expand_path("config.yml", Dir.pwd)
      opt.on("--config-file=config.yml", "Configuration file to load. Default to ./config.yml") do |path|
        $config_path = File.absolute_path(path)
      end

      $backup_dir_path = ENV["SAVE_DATA_BACKUP_DIR_PATH"] || "/tmp"
      opt.on("--backup-dir-path=/tmp", "Path to the backup directory. Default to /tmp") do |path|
        $backup_dir_path = File.absolute_path(path)
      end

      $mail = ENV["SAVE_DATA_MAIL"] == "true"
      opt.on("--mail", "Enable sending email to $USER") do
        $mail = true
      end
    end.parse!
  end

end
