module Search
  class AdminsController < Search::BaseController

    private

    def base_resources
      Admin.for_user(current_user)
    end
  end
end

