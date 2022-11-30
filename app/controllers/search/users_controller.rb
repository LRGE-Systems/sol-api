module Search
  class UsersController < Search::BaseController

    private

    def base_resources
      User.for_user(current_user)
    end
  end
end
