module ReportsService::Download
  class Base
    include TransactionMethods
    include Call::Methods

    def main_method
      execute
    end

    private

    def execute
      report.processing!

      download

      report.update!(url: name_file)
      report.success!

    rescue => error
      report.update!(
        error_message: error.message,
        error_backtrace: error.backtrace
      )

      report.error!
    end

    def download
      load_resources
      print "CARALHO7"

      generate_base_spreadsheet
      print "CARALHO6"

      load_rows
      print "CARALHO5"

      detailings
      print "CARALHO3"

      load_row_detailings
      print "CARALHO1"
      respWriet = @book.write "/home/gal/SOL/sol-api/public/#{name_file}"
      print "CARALHO2"
      print respWriet
    end

    def generate_base_spreadsheet
      @book = Spreadsheet::Write::Xls.new
      @sheet = @book.create_sheet(I18n.t("services.download.summary"))

      @book.concat_row(@sheet, 0, [sheet_row_first])
      @book.concat_row(@sheet, 1, sheet_titles_columns)
    end

    def detailings
      @sheet1 = @book.create_sheet(I18n.t("services.download.details"))
    end

    def load_row_detailings; end

    def load_resources; end

    def worksheet_name; end

    def sheet_row_first; end

    def sheet_titles_columns; end

    def load_rows; end

    def format_money(value)
      ActionController::Base.helpers.number_to_currency(value)
    end

    def name_file
      @name_file ||= "storage/#{name_key}#{DateTime.current.strftime('%d%m%Y%H%M')}.#{@book.file_extension}"
    end

    def name_key; end

  end
end
