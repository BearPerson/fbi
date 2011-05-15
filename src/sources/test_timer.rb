require 'component'

FBI::Component.start do |fbi|

  fbi.source 'test_timer' do |src|
    clock = 0
    EM.add_periodic_timer(1) do
      puts 'Sending ping'
      src.queue({
        'message' => {
          'text' => "ping #{clock += 1}"
        }
      })
    end
  end
  
end

