module Administrator
  class AdminsController < AdminController
    include CrudController
    include BaseProfilesController

    load_and_authorize_resource

    before_action :set_paper_trail_whodunnit
    before_action :skip_password_validation, on: :create

    PERMITTED_PARAMS = [
      :id, :name, :email, :password, :password_confirmation, :role
    ].freeze

    expose :admins, -> { find_admins }
    expose :admin

    private

    def skip_password_validation
      admin.skip_password_validation!
    end

    def resource
      admin
    end

    def resources
      admins.for_user(current_user)
    end

    def find_admins
      Admin.for_user(current_user).accessible_by(current_ability)
    end

    def admin_params
      pr = params.require(:admin).permit(*PERMITTED_PARAMS)
      pr[:organization] = current_user.organization
      pr
    end
  end
end
