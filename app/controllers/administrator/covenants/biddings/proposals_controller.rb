module Administrator
  class Covenants::Biddings::ProposalsController < AdminController
    include CrudController

    load_and_authorize_resource :proposal, parent: false

    expose :bidding
    expose :proposals, -> { find_proposals }

    def index
      render json: paginated_resources,
             each_serializer: Administrator::ProposalSerializer,
             include: ['lot_proposals.lot_group_item_lot_proposals.lot_group_item']
    end

    private

    def resources
      proposals.for_user(current_user)
    end

    def find_proposals
      bidding.for_user(current_user).proposals.for_user(current_user).accessible_by(current_ability).active_and_orderly
    end
  end
end
