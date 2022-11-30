module Administrator
  class SuppliersController < AdminController
    include CrudController

    load_and_authorize_resource

    before_action :set_paper_trail_whodunnit
    before_action :skip_password_validation, on: :create

    PERMITTED_PARAMS = [
      :id, :name, :email, :cpf, :phone, :provider_id
    ].freeze

    expose :suppliers, -> { find_suppliers }
    expose :supplier

    private

    def skip_password_validation
      supplier.skip_password_validation!
    end

    def resource
      supplier
    end

    def resources
      suppliers.for_user(current_user)
    end

    def find_suppliers
      Supplier.for_user(current_user).accessible_by(current_ability)
    end

    def supplier_params
      pr = params.require(:supplier).permit(*PERMITTED_PARAMS)
      pr[:organization] = current_user.organization
      pr
    end
  end
end
