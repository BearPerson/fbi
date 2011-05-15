require 'rubygems'
require 'amqp'

AMQP.start(:host => 'localhost') do

  amq = MQ.new

  exchange = amq.fanout('fbi.sinks', {
    :durable => true
  })
  amq.queue('fbi.sources').subscribe do |msg|
    p msg
    
    exchange.publish(msg)
  end

end

