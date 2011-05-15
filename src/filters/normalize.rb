require 'filters'

module FBI::Filters
  class Normalize < FBI::Filter
    def filter message
      return unless message['message']
      return unless message['message']['text']
      return unless message['message']['project']

      type = (message['message']['type'] ||= 'plain')

      message[type] ||= {}

      timestamp = message['message']['timestamp'] || Float::MAX
      now = Time.new.to_f
      if timestamp > now then
        message['message']['timestamp'] = now
      end

      message.keys.each do |key|
        if key != 'message' and key != type then
          message.delete(key)
        end
      end

      message['system'] = {}

      self.push message
    end
  end
end
