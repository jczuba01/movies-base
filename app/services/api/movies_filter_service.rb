module Api
  class MoviesFilterService < Api::BaseFilterService
    private

    def apply_filters(result)
      result = filter_by_title(result)
      result = filter_by_genre_name(result)
      result = filter_by_director_last_name(result) 
      result = filter_by_duration(result)
      result = filter_by_origin_country(result)
      result
    end

    def filter_by_title(result)
      return result unless params[:title].present?
      result.where("title ILIKE ?", "%#{params[:title]}%")
    end

    def filter_by_genre_name(result)
      return result unless params[:genre_name].present?
      result = result.joins(:genre)
      result.where("genres.name ILIKE ?", "%#{params[:genre_name]}%")
    end

    def filter_by_director_last_name(result)
      return result unless params[:director_last_name].present?
      result = result.joins(:director)
      result.where("directors.last_name ILIKE ?", "%#{params[:director_last_name]}%")
    end

    def filter_by_duration(result)
      return result unless params[:max_duration].present?
      result.where("duration_minutes <= ?", params[:max_duration])
    end

    def filter_by_origin_country(result)
      return result unless params[:origin_country].present?
      result.where(origin_country: params[:origin_country])
    end
  end
end