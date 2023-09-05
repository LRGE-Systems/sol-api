module BiddingsService::Minute
  class PdfGenerate < Base
    private

    def minute_html_template
      puts "!! STARTING BIDDING PDF GENERATE SERVICE"
      template_service.call
    end

    def template_service
      Pdf::Bidding::Minute::TemplateStrategy.decide(bidding: bidding)
    end

    def file_type
      'minute'
    end
  end
end
