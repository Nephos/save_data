# coding: utf-8

module Backup

  class Git < Core

    def regen_cmd(save_name = nil)
      save_name ||= self.name
      out_dir = "#{name}.git"
      log_file = "/tmp/#{name}_#{time}.log"
      "git clone #{@params["user"]}@#{@params["domain"]}:#{@params["directory"]} #{@params["directory"]} > #{log_file}" # add the port number
    end
  end

  class GitTest < Git
    def execute
      super() do |dir|
        puts "#{dir} $> #{self.cmd}"
      end
    end
  end

end
