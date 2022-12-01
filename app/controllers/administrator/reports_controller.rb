module Administrator
  class ReportsController < AdminController
    include CrudController

    load_and_authorize_resource

    PERMITTED_PARAMS = [:report_type].freeze

    expose :reports, -> { find_reports }
    expose :report

    private

    def created?
      report_service.async_call
      report = report_service.report
      report.try(:valid?)
    end

    def resource
      report
    end

    def resources
      reports.for_user(current_user)
    end

    def default_sort_scope
      resources.for_user(current_user)
    end

    def find_reports
      Report.for_user(current_user).where(filter_params).accessible_by(current_ability)
    end

    def report_params
      pr = params.require(:report).permit(*PERMITTED_PARAMS)
      pr[:organization_id] = current_user.organization_id
      pr
    end

    def report_service
      @report_service ||=
        ReportsService::Create.new(
          admin: current_user, report_type: report_params[:report_type]
        )
    end

    def filter_params
      { report_type: report_type, status: status }.delete_if { |_, value| value.blank? }
    end

    def report_type
      params['report_type']
    end

    def status
      params['status']
    end
  end
end
