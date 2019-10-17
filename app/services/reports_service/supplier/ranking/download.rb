module ReportsService::Supplier
  class Ranking::Download < ReportsService::Download::Base

    private

    def load_resources
      provider_all
    end

    def load_rows
      summary
    end

    def load_row_detailings
      detailing
    end

    def worksheet_name
      I18n.t('services.download.supplier.ranking.worksheet')
    end

    def sheet_row_first
      I18n.t('services.download.supplier.ranking.worksheet')
    end

    def sheet_titles_columns
      [
        I18n.t('services.download.supplier.ranking.column_1'),
        I18n.t('services.download.supplier.ranking.column_2'),
        I18n.t('services.download.supplier.ranking.column_3')
      ]
    end

    def name_key
      'ranking_fornecedores_'
    end

    def summary
      i = 2
      @providers.each do |provider|
        next if contracts(provider).count == 0
        @book.replace_row @sheet, i, summary_values(provider)
        i += 1
      end
    end

    def detailing
      i = 0
      @book.concat_row(@sheet1, i, sheet_detailing_title_columns)
      i += 1

      @providers.each do |provider|
        contracts(provider).each do |contract|
          sheet_rows_detailing(contract, provider, i)
          i += 1
        end
      end
    end

    def summary_values(provider)
      [
        provider.name,
        contracts(provider).count,
        price_total_contracts(provider)
      ]
    end

    def sheet_detailing_title_columns
      [
        I18n.t('services.download.supplier.ranking.column_4'),
        I18n.t('services.download.supplier.ranking.column_5'),
        I18n.t('services.download.supplier.ranking.column_6'),
        I18n.t('services.download.supplier.ranking.column_7'),
        I18n.t('services.download.supplier.ranking.column_8'),
        I18n.t('services.download.supplier.ranking.column_9'),
        I18n.t('services.download.supplier.ranking.column_10')
      ]
    end

    def sheet_rows_detailing(contract, provider, i)
      @book.replace_row(@sheet1, i, sheet_rows_detailing_values(contract, provider))
    end

    def sheet_rows_detailing_values(contract, provider)
      [
        provider.name,
        provider.document,
        "##{contract.id}",
        cooperative(contract).name,
        cooperative(contract).cnpj,
        bidding(contract).title,
        price_total_contract(contract)
      ]
    end

    def contracts(provider)
      ::Contract.where(supplier: provider.suppliers).order(:id)
    end

    def cooperative(contract)
      contract.proposal.bidding.cooperative
    end

    def bidding(contract)
      contract.proposal.bidding
    end

    def price_total_contract(contract)
      format_money(contract.proposal.price_total)
    end

    def price_total_contracts(provider)
      format_money(contracts(provider).joins(:proposal).sum('proposals.price_total'))
    end

    def provider_all
      @providers = Provider.all
    end

    def name_key
      'ranking_fornecedores_'
    end
  end
end
