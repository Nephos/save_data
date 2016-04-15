require_relative 'Backup'

module Backup

  class MongoDB < Interface
    def initialize(backup_dir: '/tmp/', name: nil, domain: nil, port: nil, database: nil, user: nil, password: nil)
      @backup_dir = backup_dir
      super(name: name, domain: domain, port: port, database: database, user: user, password: password)
    end

    def regen_cmd(save_name = nil)
      save_name ||= self.name
      out_dir = "#{name}_#{time}.dir"
      log_file = "/tmp/#{name}_#{time}.log"
      tar_file = File.expand_path "#{name}_#{time}.tar.gz", @backup_dir
      [
        "mongodump -h #{domain}:#{port} -d #{database} -u #{user} -p #{password} -o #{out_dir} > #{log_file}",
        "tar -acf #{tar_file} #{out_dir}"
      ].join(" && ")
    end
  end

  class MongodbTest < MongoDB
    def execute
      super() do |dir|
        puts "#{dir} $> #{self.cmd}"
      end
    end
  end

end
