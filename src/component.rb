require 'rubygems'
require 'amqp'
require 'json'

module FBI
  class Component
    
    def self.start
      component = new()

      AMQP::Channel.error do |msg|
        print "ERROR: #{msg}\n"
        EM.stop
      end
      
      AMQP.start(:host => 'localhost') do
        yield component
      end
    end

    def temporary_sink name, &blck
      Sink.new self, false, name, &blck
    end
    
    def sink name, &blck
      Sink.new self, true, name, &blck
    end
    
    def source name
      source = Source.new self
      yield source
    end
  end
  
  class Sink
    attr_reader :queue, :component
    
    def initialize component, persistent, name, &blck
      @component = component
      if (persistent) then
        @queue = MQ.new.queue("fbi.sink-#{name}", {
          :durable => true
        })
      else
        @queue = MQ.new.queue("fbi.sink-#{name}.temp", {
          :exclusive => true,
          :auto_delete => true
        })
      end
      @queue.bind('fbi.sinks')
      
      @queue.subscribe {|msg|
        parsed = JSON.parse(msg)
        blck.call parsed, self
      }
    end
  end
  
  class Source
    attr_reader :queue, :component
    
    def initialize component
      @component = component
      @queue = MQ.new.queue('fbi.sources')
    end
    
    def queue packet
      @queue.publish JSON.generate(packet)
    end
  end
end

