module Coop
  class CovenantsController < CoopController
    include CrudController

    load_and_authorize_resource

    expose :covenants, -> { find_covenants }
    expose :covenant

    private

    def resource
      covenant
    end

    def resources
      covenants.for_user(current_cooperative)
    end

    def find_covenants
      current_cooperative.covenants.for_user(current_cooperative).accessible_by(current_ability)
    end
  end
end
