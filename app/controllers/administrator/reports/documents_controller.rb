module Administrator
  class Reports::DocumentsController < AdminController
    def index
      render json: ReportsService::Document.call
    end
  end
end
