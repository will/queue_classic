module QC
  class Queue

    attr_reader :name, :chan

    def initialize(name, notify=QC::LISTENING_WORKER)
      @name = name
      @chan = @name if notify
    end

    def enqueue(method, *args)
      Queries.insert(name, method, args, chan)
    end

    def lock(top_bound=TOP_BOUND)
      Queries.pop(name)
    end

    def delete_all
      Queries.delete_all(name)
    end

    def count
      Queries.count(name)
    end

  end
end
