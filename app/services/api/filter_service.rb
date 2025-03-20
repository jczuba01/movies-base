module Api
  class FilterService
    attr_reader :collection, :params

    def initialize(collection, params = {})
      @collection = collection
      @params = params
    end

    def call
      result = collection
      result = apply_filters(result)
      result = apply_sorting(result)
      result
    end

    private

    def apply_filters(result)
      result
    end

    def apply_sorting(result)
      if params[:sort].present?
        direction = params[:direction]&.downcase == 'desc' ? :desc : :asc
        sort_column = params[:sort]

        if result.column_names.include?(sort_column)
          result = result.order("#{sort_column} #{direction}")
        end
      end

      result
    end
  end
end