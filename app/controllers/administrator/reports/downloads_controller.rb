module Administrator
  class Reports::DownloadsController < AdminController
    expose :report

    def show
      if report.url.present?
        send_file "/home/gal/SOL/sol-api/public/#{report.url}", type: "application/xlsx"
      else
        render status: :not_found
      end
    end
  end
end
