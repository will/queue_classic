module QC
  module Conn
    extend self

    def notify(chan)
      log(:level => :debug, :action => "NOTIFY")
    end

    def listen(chan)
      log(:level => :debug, :action => "LISTEN")
    end

    def unlisten(chan)
      log(:level => :debug, :action => "UNLISTEN")
    end

    def drain_notify
      until connection.notifies.nil?
        log(:level => :debug, :action => "drain_notifications")
      end
    end

    def wait_for_notify(t)
      connection.wait_for_notify(t) do |event, pid, msg|
        log(:level => :debug, :action => "received_notification")
      end
    end

    def connection
      @connection ||= connect
    end

    def disconnect
      connection.quit
    ensure
      @connection = nil
    end

    def connect
      Redis.new(url: db_url, driver: :hiredis)
    end

    def db_url
      return @db_url if @db_url

      if ENV["REDIS_URL"]
        @db_url = ENV["REDIS_URL"]
      elsif ENV["REDIS_PROVIDER"] && ENV[ENV["REDIS_PROVIDER"]]
        @db_url = ENV[ENV["REDIS_PROVIDER"]]
      else
        raise(ArgumentError, "missing REDIS_PROVIDER or REDIS_URL")
      end
    end

    def log(msg)
      QC.log(msg)
    end

  end
end
