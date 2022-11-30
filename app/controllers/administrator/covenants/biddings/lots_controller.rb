module Administrator
  class Covenants::Biddings::LotsController < AdminController
    include CrudController

    load_and_authorize_resource :lot, parent: false

    expose :bidding
    expose :lots, -> { find_lots }
    expose :lot

    def index
      render json: paginated_resources, each_serializer: Coop::LotSerializer
    end

    private

    def resource
      lot
    end

    def resources
      lots.for_user(current_user)
    end

    def find_lots
      bidding.for_user(current_user).lots.for_user(current_user).accessible_by(current_ability)
    end
  end
end
