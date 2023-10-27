module Administrator
  class Reports::ContractsController < AdminController
    def index
      render json: ReportsService::Contract.new(user:current_user).call 
    end
  end
end
