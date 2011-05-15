require 'component'

FBI::Component.start do |fbi|

  fbi.temporary_sink 'tail' do |msg, sink|
    p msg
  end

end

