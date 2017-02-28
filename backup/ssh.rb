# coding: utf-8

module Backup

  class Ssh < Core
    def regen_cmd(save_name = nil)
      save_name ||= self.name
      out_dir = "#{name}.git"
      log_file = "/tmp/#{name}_#{time}.log"
      "scp -P #{@params["port"]} -r #{@params["user"]}@#{@params["domain"]}:#{@params["directory"]} . > #{log_file}"
    end
  end

  class SshTest < Ssh
    def execute
      super() do |dir|
        puts "#{dir} $> #{self.cmd}"
      end
    end
  end

end
