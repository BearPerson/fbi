require 'component'

FBI::Component.start do |fbi|

  fbi.sink 'nil' do |msg, sink|
    p msg
  end

end

