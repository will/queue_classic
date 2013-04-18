require "scrolls"
require "hiredis"
require "redis"
require "uri"

require "queue_classic/okjson"
require "queue_classic/conn"
require "queue_classic/queries"
require "queue_classic/queue"
require "queue_classic/worker"

module QC
  Root = File.expand_path("..", File.dirname(__FILE__))

  # Each row in the table will have a column that
  # notes the queue. You can point your workers
  # at different queues but only one at a time.
  QUEUE = ENV["QUEUE"] || "default"

  MAX_LOCK_ATTEMPTS = 5
  LISTENING_WORKER = false

  # Set this variable if you wish for
  # the worker to fork a UNIX process for
  # each locked job. Remember to re-establish
  # any database connections. See the worker
  # for more details.
  FORK_WORKER = !ENV["QC_FORK_WORKER"].nil?

  # Defer method calls on the QC module to the
  # default queue. This facilitates QC.enqueue()
  def self.method_missing(sym, *args, &block)
    default_queue.send(sym, *args, &block)
  end

  def self.default_queue
    @default_queue ||= begin
      Queue.new(QUEUE)
    end
  end

  def self.log_yield(data)
    begin
      t0 = Time.now
      yield
    rescue => e
      log({:level => :error, :error => e.class, :message => e.message.strip}.merge(data))
      raise
    ensure
      t = Integer((Time.now - t0)*1000)
      log(data.merge(:elapsed => t)) unless e
    end
  end

  def self.log(data)
    Scrolls.log({:lib => :queue_classic}.merge(data))
  end

end
