require './lib/dashboards/supplier'

module Supp
  class DashboardsController < SuppController
    expose :biddings, -> { find_biddings }

    def show
      render json: supplier_dashboard_json
    end

    private

    def supplier_dashboard_json
      ::Dashboards::Supplier.new(biddings: biddings).to_json
    end

    def find_biddings
      Bidding.where(Bidding.arel_table[:start_date].lteq(Date.current)).by_provider(current_provider).accessible_by(current_ability).sorted.distinct('biddings.id')
    end
  end
end
