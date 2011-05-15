require 'component'

FBI::Component.start do |fbi|

  fbi.source 'test_timer' do |src|
    EM.add_periodic_timer(1) do
      puts 'Sending ping'
      src.queue 'ping'
    end
  end
  
end

