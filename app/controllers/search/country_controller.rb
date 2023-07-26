module Search
  class CountryController < Search::BaseController
    skip_before_action :auth!

    private

    def base_resources
      Country
    end
  end
end
