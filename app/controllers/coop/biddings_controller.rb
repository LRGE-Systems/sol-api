module Coop
  class BiddingsController < CoopController
    include CrudController

    load_and_authorize_resource

    PERMITTED_PARAMS = [
      :title, :description, :kind, :modality, :status, :deadline, :link, :start_date,
      :closing_date, :covenant_id, :address, :draw_end_days, :classification_id,
      invites_attributes: [
        :id, :provider_id, :_destroy
      ]
    ].freeze

    expose :biddings, -> { find_biddings }
    expose :bidding

    before_action :set_paper_trail_whodunnit

    private

    def find_biddings
      Bidding.by_cooperative(current_cooperative.id).accessible_by(current_ability)
    end

    def resource
      bidding
    end

    def resources
      biddings.for_user(current_cooperative)
    end

    def bidding_params
      pr = params.require(:bidding).permit(*PERMITTED_PARAMS)
      pr[:organization_id] = current_cooperative.organization_id
      pr
    end
  end
end
