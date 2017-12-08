# coding: utf-8
require_relative 'core'

module Backup

  class Mongodb < Core
    def regen_cmd(save_name = nil)
      save_name ||= self.name
      log_file = "/tmp/#{name}_#{time}.log"
      "mongodump -h #{params['domain']}:#{@params['port']} -d #{@params['database']} -u #{@params['user']} -p #{@params['password']} -o . > #{log_file}"
    end
  end

  class MongodbTest < Mongodb
    def execute
      super() do |dir|
        puts "#{dir} $> #{self.cmd}"
      end
    end
  end

end
