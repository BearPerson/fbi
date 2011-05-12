require 'rubygems'
require 'amqp'

module FBI
  class Component
    
    def self.start
      component = new()
      
      AMQP.start(:host => 'localhost') do
        yield component
      end
    end
    
    def sink name, &blck
      Sink.new self, name, &blck
    end
    
    def source name
      source = Source.new self
      yield source
    end
  end
  
  class Sink
    attr_reader :amq, :queue, :component
    
    def initialize component, name, &blck
      @component = component
      @amq = MQ.new
      @queue = @amq.queue("sink-#{name}")
      
      @queue.subscribe {|msg| blck.call msg, self }
    end
  end
  
  class Source
    attr_reader :amq, :queue, :component
    
    def initialize component
      @component = component
      @amq = MQ.new
      @queue = @amq.queue('raw')
    end
    
    def queue packet
      @queue.publish packet
    end
  end
end

