# coding: utf-8

module Backup

  class PostgreSql < Core

    def regen_cmd(save_name = nil)
      save_name ||= self.name
      out_dir = "#{name}.git"
      log_file = "/tmp/#{name}_#{time}.log"

      commands = @params['databases'].map do |db|
        command = "echo #{@params['password']} | pg_dump -U #{@params['user']} -h #{@params['domain']} -p #{@params['port']} -F t #{db} > /tmp/#{db}.tar"
        if @params['ssh']
          [
            "ssh #{@params['ssh']['user']}@#{@params['ssh']['domain']} -p #{@params['ssh']['port']} '#{command}'",
            "scp -P #{@params['ssh']['port']} #{@params['ssh']['user']}@#{@params['ssh']['domain']}:/tmp/#{db}.tar ."
          ].join(" && ")
        else
          command
        end
      end

      commands.join(" && ")
    end
  end

  class PostgreSqlTest < Git
    def execute
      super() do |dir|
        puts "#{dir} $> #{self.cmd}"
      end
    end
  end

end
