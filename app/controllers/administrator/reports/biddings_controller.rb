module Administrator
  class Reports::BiddingsController < AdminController
    def index
      render json: ReportsService::Bidding.new(user:current_user).call
    end
  end
end
