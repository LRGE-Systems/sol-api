module Search
  class CitiesController < Search::BaseController
    skip_before_action :auth!

    private

    def base_resources
      if params[:country].blank? || params[:country] == "null"
        City.includes(:state)
      else 
        City.includes(:state).where(states: {
          country_id: params[:'country']
        })
      end
    end
  end
end
