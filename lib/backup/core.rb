require 'tmpdir'

module Backup
  class Backup::Core
    attr_reader :cmd, :params, :name, :output_dir, :time

    def initialize(name, output_dir, params)
      @time = Time.now.to_i
      @name = name
      @output_dir = output_dir
      @params = params
      @cmd = params["cmd"] || regen_cmd(name)
    end

    # Must be implemented to generate a correct cmd that can be executed to execute the backup
    def regen_cmd(save_name = nil)
      raise "Not Implemented for #{self.class}"
    end

    # Go into a temporary directory to download data
    # Then execute the commands
    # Then archive the content
    def execute
      current_dir = Dir.pwd
      begin
        Dir.mktmpdir("#{@name}.backup") do |tmp_dir|
          Dir.chdir tmp_dir
          Dir.mkdir @name
          Dir.chdir @name
          if block_given?
            yield(dir) # to be used in "super() do { ... }"
          else
            puts `#{self.cmd}`
          end
          Dir.chdir tmp_dir
          tar_file = "#{tmp_dir}.tar.gz"
          `tar -acf #{tar_file} #{@name}`
          `mkdir -p #{@output_dir} && mv -v #{tar_file} #{@output_dir}`
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
end
