require 'tmpdir'

module Backup
end

class Backup::Core
  attr_reader :cmd, :params, :name, :output_dir, :time

  def initialize(name, output_dir, params)
    @name = name
    @output_dir = output_dir
    @params = params
    @cmd = params["cmd"] || regen_cmd(name)
    @time = Time.now.to_i
  end

  # Must be implemented to generate a correct cmd
  def regen_cmd(save_name = nil)
    raise "Not Implementd for #{self.class}"
  end

  # Go into a temporary directory to download data
  # Then execute the commands
  # Then archive the content
  def execute
    current_dir = Dir.pwd
    begin
      Dir.mktmpdir("#{@name}.backup.") do |dir|
        Dir.chdir dir
        Dir.mkdir @name
        Dir.chdir @name
        block_given? ? yield(dir) : puts(`#{self.cmd}`) # to be used in "super() do { ... }"
        Dir.chdir dir
        tar_file = "#{dir}.tar.gz"
        puts `tar -acf #{tar_file} #{@name}`
        puts `mkdir -p #{@output_dir} && mv -v #{tar_file} #{@output_dir}`
      end
    rescue => err
      STDERR.puts "Error: #{err}".red
      return nil
    ensure
      Dir.chdir(current_dir)
    end

    self.cmd
  end

end
