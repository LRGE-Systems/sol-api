module Search
  class OrganizationsController < Search::BaseController
    skip_before_action :auth!

    private

    def base_resources
      Organization
    end
  end
end
