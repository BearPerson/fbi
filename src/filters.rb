module FBI
  class FilterChain
    attr_reader :filters

    def initialize filters, &blck
      @callback = blck
      @filters = filters
    end

    def filter message, start=0
      @filters.each do |filter|
        if not filter.filter(message) then
          return
        end
      end
      @callback.call(message)
    end
  end

  class Filter
    def filter message
      raise NotImplementedError, "Filter#filter should modify message and return true or false"
    end
  end
end
