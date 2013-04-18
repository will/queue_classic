module QC
  module Queries
    extend self

    def insert(q_name, method, args, chan=nil)
      QC.log_yield(:action => "insert_job") do
        Conn.connection.rpush q_name, OkJson.encode({'method' => method, 'args' => args})
        #Conn.notify(chan) if chan
      end
    end

    def pop(q_name)
      res = Conn.connection.blpop(q_name).last
      json = OkJson.decode( res )
      {
        method: json['method'],
        args:   json['args']
      }
    end

    def count(q_name)
      Conn.connection.llen(q_name)
    end

    def delete_all(q_name=nil)
      Conn.connection.del q_name if q_name
    end

  end
end
