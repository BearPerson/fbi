require 'rubygems'
require 'amqp'
require 'json'

require 'filters'
require 'filters/normalize'

filters = [
  FBI::Filters::Normalize.new,
]

AMQP.start(:host => 'localhost') do

  amq = AMQP::Channel.new

  exchange = amq.fanout('fbi.sinks', {
    :durable => true
  })

  chain = FBI::FilterChain.new(filters) { |msg|
    exchange.publish(JSON.generate(msg))
  }

  amq.queue('fbi.sources').subscribe do |msg|
    p msg

    decoded = JSON.parse(msg)

    chain.filter(decoded)
  end

end

