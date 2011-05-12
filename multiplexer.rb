require 'rubygems'
require 'amqp'

SINKS = ['nil']

AMQP.start(:host => 'localhost') do

  amq = MQ.new
  amq.queue('raw').subscribe do |msg|
    p msg
    
    SINKS.each do |sink|
      amq.queue("sink-#{sink}").publish(msg)
    end
  end

end

