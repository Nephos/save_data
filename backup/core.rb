require 'tmpdir'

module Backup
  class Core
    attr_accessor :name, :domain, :port, :database, :user, :password
    attr_reader :cmd, :time
    def initialize(name: nil, domain: nil, port: nil, database: nil, user: nil, password: nil)
      # TODO: no nil value
      @name = name || database
      @domain = domain
      @port = port
      @database = database
      @user = user
      @password = password
      @time = Time.now.to_i
      @cmd = regen_cmd(name)
    end

    def regen_cmd(save_name = nil)
      raise "Not Implementd for #{self.class}"
    end

    def execute
      current_dir = Dir.pwd
      begin
        Dir.mktmpdir('save_data_') do |dir|
          Dir.chdir dir
          block_given? ? yield(dir) : `#{self.cmd}`
        end
      rescue
        return nil
      ensure
        Dir.chdir(current_dir)
      end
      self.cmd
    end
  end
end
