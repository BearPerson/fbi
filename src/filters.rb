module FBI
  class FilterChain
    attr_reader :filters

    def initialize filters, &blck
      @filters = filters.clone
      @filters.push FilterTail.new blck

      @filters[0..-2].each_with_index do |filter, index|
        filter.bind { |message|
          @filters[index+1].filter(message)
        }
      end
    end

    def filter message, start=0
      @filters[start].filter(message)
    end
  end

  class Filter
    def bind &blck
      @callback = blck
    end

    def push message
      @callback.call(message)
    end
  end

  class FilterTail
    def initialize callback
      @callback = callback
    end

    def filter message
      @callback.call(message)
    end
  end
end
