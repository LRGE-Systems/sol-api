module Pdf::Contract::Classification
  class Base
    include Call::Methods
    include ActionView::Helpers::NumberHelper
    include Pdf::HelperMethods

    attr_accessor :html, :table, :template

    def initialize(*args)
      super
      @template = template_file_name
      @html = template_data
      @table = fill_table_header
    end

    def main_method
      parse_html
    end

    private

    def parse_html
      return unless (( !contract.blank? && contract.all_signed?) || (!bidding.blank?))

      dictionary.each do |key, value|
        nval = value
        nval = key if value == "NODEF"
        html.gsub!(key, nval.to_s)
      end

      html
    end

    def dictionary
      {
        "@@cooperative_country@@" => cooperative.address.country,
        "@@provider_country@@" => (contract.blank? ? "NODEF" : provider.address.country),
        "@@bidding_link@@" => bidding.link ,
        "@@bidding_start_date@@" => bidding.start_date ,
        '@@project_name@@' => bidding.organization.name,
        '@@bidding_country@@' => bidding.organization.country,
        '@@name_cooperative@@' => cooperative.name,
        '@@cooperative_address@@' => cooperative_address,
        '@@cooperative_legal_representative_name@@' => cooperative_legal_representative_name,
        '@@cooperative_legal_representative_email@@' => cooperative_legal_representative_email,
        '@@name_provider@@' => (contract.blank? ? "NODEF" : provider.name),
        '@@document_provider@@' => (contract.blank? ? "NODEF" : provider.document),
        '@@provider_address@@' => (contract.blank? ? "NODEF" : provider_address),
        '@@provider_legal_representative_email@@' => (contract.blank? ? "NODEF" : provider_legal_representative_email),
        '@@provider_legal_representative_name@@' => (contract.blank? ? "NODEF" : provider_legal_representative_name),
        '@@lot_name@@' => lot_name,
        '@@title_bidding@@' => bidding.title,
        '@@total_value@@' => formatted_total_value,
        '@@total_full_value@@' => total_full_value,
        '@@number_covenant@@' => bidding.covenant.number,
        '@@env_name_state@@' => pdf_contract_env('NAME_STATE'),
        '@@address_delivery@@' => address_bidding_or_lot,
        '@@deadline_contract@@' => (contract.blank? ? "NODEF" : contract.deadline - 60),
        '@@deadline_lot@@' => deadline(lot),
        '@@city_cooperative@@' => cooperative.address.city.name,
        '@@date_today@@' => (contract.blank? ? "NODEF" : I18n.l(contract.supplier_signed_at.to_date)),
        '@@user_signed_at_contract@@' => (contract.blank? ? "NODEF" : I18n.l(contract.user_signed_at, format: :shorter)),
        '@@name_supplier@@' => (contract.blank? ? "NODEF" : contract.supplier.name),
        '@@supplier_signed_at_contract@@' => (contract.blank? ? "NODEF" : I18n.l(contract.supplier_signed_at, format: :shorter)),
        '@@items_lot@@' => fill_table,
        '@@env_contract_join@@' => pdf_contract_env('CONTRACT_JOIN'),
        '@@env_covenant_resource@@' => pdf_contract_env('COVENANT_RESOURCE'),
        '@@env_loan@@' => pdf_contract_env('LOAN'),
        '@@cooperative_state@@' => cooperative_state,
        '@@cooperative_legal_representative_cpf@@' => cooperative_legal_representative_cpf,
        '@@provider_legal_representative_cpf@@' => (contract.blank? ? "NODEF" : provider_legal_representative_cpf),
        '@@env_department_development@@' => pdf_contract_env('DEPARTMENT_DEVELOPMENT'),
        '@@env_foro@@' => pdf_contract_env('FORO'),
        '@@env_productive_program@@' => pdf_contract_env('PRODUCTIVE_PROGRAM'),
        '@@env_crea@@' => pdf_contract_env('CREA'),
        '@@env_development_action_company@@' => pdf_contract_env('DEVELOPMENT_ACTION_COMPANY'),
        '@@delivery_price@@' => delivery_price,
        '@@lot_address@@' => address_bidding_or_lot,
        '@@contract_value@@' => (contract.blank? ? "NODEF" : contract_value),
        '@@number_contract@@' => (contract.blank? ? "NODEF" : contract.title),
        '@@date_contract@@' => date_full,
        '@@items_name@@' => items_name,
        '@@cnpj_cooperative@@' => cooperative.cnpj
      }
    end

    def date_full
      return "NODEF" if contract.blank?
      @date_full ||= I18n.l(contract.created_at, format: :date_contract)
    end

    def items_name
      return "NODEF" if contract.blank?
      contract.lot_group_item_lot_proposals.map do |lot_group_item_lot_proposal|
        lot_group_item_lot_proposal.item.description
      end.uniq.to_sentence
    end

    def deadline(lot)
      return "NODEF" if contract.blank?
      lot.deadline.nil? ? lot.bidding.deadline : lot.deadline
    end

    def contract_value
      return "NODEF" if contract.blank?
      value = contract.proposal.price_total
      formatted_currency(value)
    end

    def delivery_price
      return "NODEF" if contract.blank?
      formatted_currency(lot_proposal.delivery_price)
    end

    def lots_list
      contract.proposal.lot_group_item_lot_proposals.map do |lot_group_item_lot_proposal|
        annex_lots(lot_group_item_lot_proposal)
      end
    end

    def annex_lots(lot_group_item_lot_proposal)
      I18n.t("document.pdf.contract.annex_lots") % [
        lot_group_item_lot_proposal.lot_proposal.lot.name,
        deadline(lot_group_item_lot_proposal.lot_proposal.lot),
        formatted_currency(lot_group_item_lot_proposal.lot_proposal.delivery_price)
      ]
    end

    def fill_table
      return "NODEF" if contract.blank?
      rows_table.each_with_index.map do |rows, index|
        table_items = "#{annexs_html[index]}<table class='table' align='center'>#{table}"
        rows(rows, index, table_items)
        table_items << "</table>"
      end.join('<br/>')
    end

    def rows(rows, index, table_items)
      if rows.is_a? Array
        rows.map{ |row| table_items << row }
      else
        table_items << rows
      end
    end

    def rows_table
      return "NODEF" if contract.blank?
      contract.proposal.lot_group_item_lot_proposals.map do |lot_group_item_lot_proposal|
        fill_table_row(lot_group_item_lot_proposal)
      end
    end

    def annexs_html
      return "NODEF" if contract.blank?
      @annexs_html ||= lots_list.map{|x| "<p class='center'>#{x}</p><br/>"}.uniq
    end

    def fill_table_header
      "<tr>"\
        "<th>#{I18n.t("document.pdf.contract.table.header.title")}</th>"\
        "<th>#{I18n.t("document.pdf.contract.table.header.description")}</th>"\
        "<th>#{I18n.t("document.pdf.contract.table.header.classification")}</th>"\
        "<th>#{I18n.t("document.pdf.contract.table.header.unit")}</th>"\
        "<th>#{I18n.t("document.pdf.contract.table.header.quantity")}</th>"\
        "<th>#{I18n.t("document.pdf.contract.table.header.unit_price")}</th>"\
        "<th>#{I18n.t("document.pdf.contract.table.header.price")}</th>"\
      "</tr>"
    end

    def fill_table_row(lot_group_item_lot_proposal)
      return "NODEF" if contract.blank?
      "<tr>"\
        "<td>#{lot_group_item_lot_proposal.item.title}</td>"\
        "<td>#{lot_group_item_lot_proposal.item.description}</td>"\
        "<td>#{lot_group_item_lot_proposal.item.classification.name}</td>"\
        "<td>#{lot_group_item_lot_proposal.item.unit.name}</td>"\
        "<td>#{formatted_number(lot_group_item_lot_proposal.lot_group_item.quantity)}</td>"\
        "<td>#{formatted_currency(lot_group_item_lot_proposal.price)}</td>"\
        "<td>#{price_total_lot(lot_group_item_lot_proposal)}</td>"\
      "</tr>"
    end

    def formatted_currency(value)
      number_to_currency(value)
    end

    def formatted_number(value)
      number_with_delimiter(value)
    end

    def prepare_currency(value)
      value.delete(',').delete('.').delete('R$ ').to_i
    end

    # TODO: move these methods to a contract decorator
    def address_bidding_or_lot
      return "NODEF" if contract.blank? 
      return bidding.address unless bidding.address.empty?
      return lots.map(&:address).to_sentence if global?

      lot.address
    end

    def cooperative_address
      full_address(cooperative.address)
    end

    def cooperative_state
      cooperative.address.state.name
    end

    def provider_address
      (contract.blank? ? "NODEF" : full_address(provider.address))
    end

    def cooperative_legal_representative_name
      legal_representative(cooperative).name
    end

    def cooperative_legal_representative_email
      legal_representative(cooperative).email
    end

    def provider_legal_representative_name
      (contract.blank? ? "NODEF" : legal_representative(provider).name)
    end

    def provider_legal_representative_email
      (contract.blank? ? "NODEF" : legal_representative(provider).email)
    end

    def cooperative_legal_representative_cpf
      legal_representative(cooperative).cpf
    end

    def provider_legal_representative_cpf
      (contract.blank? ? "NODEF" : legal_representative(provider).cpf)
    end

    def lot_name
      return "NODEF" if contract.blank?

      return lots.map(&:name).to_sentence if global?

      lot.name
    end

    def formatted_total_value
      (contract.blank? ? "NODEF" : formatted_currency(total_value) )
    end

    def price_total_lot(lot_group_item_lot_proposal)
      if contract.blank?
        return "NODEF"
      end
      quantity = lot_group_item_lot_proposal.lot_group_item.quantity
      price = lot_group_item_lot_proposal.price
      formatted_currency(quantity * price)
    end

    def total_full_value
      if contract.blank? 
        return "NODEF"
      end
      value = prepare_currency(formatted_total_value)
      valid_value_for_full_text?(value) ? Extenso.moeda(value) : nil
    end

    def total_value
      @total_value ||= (contract.blank? ? "NODEF" : contract.proposal.price_total)
    end

    def lot
      @lot ||= (contract.blank? ? "NODEF" : lot_proposal.lot)
    end

    def lot_proposal
      @lot_proposal ||= (contract.blank? ? "NODEF" : contract.proposal.lot_proposals.first)
    end

    def lots
      @lots ||= (contract.blank? ? "NODEF" : contract.proposal.lots)
    end

    def full_address(address)
      "#{address.address}, #{address_complement_number(address)}, " \
      "#{address.cep}, #{address.city.name}, #{address.state.name}, #{address.country}"
    end

    def address_complement_number(address)
      number_complement = address.number
      number_complement << ", #{address.complement}" if address.complement.present?
      number_complement
    end

    def cooperative
      @cooperative ||= (contract.blank? ? bidding.cooperative : (contract.user.cooperative) )
    end

    def provider
      @provider ||= (contract.blank? ? "NODEF" : (contract.supplier.provider))
    end

    def bidding
      @bidding ||= contract.blank? ? biddingTop : contract.bidding
    end

    def global?
      bidding.global?
    end

    def legal_representative(klass)
      klass.legal_representative
    end

    def template_data
      @template_data ||=
        File.read(
          Rails.root.join('lib', 'pdf', 'contract', 'classification', 'templates', template)
        )
    end

    def pdf_contract_env(key)
      ENV["PDF_CONTRACT_#{key}"]
    end

    def localeBase
      return (contract.blank? ? bidding : contract.user).organization.locale
    end

    def template_file_name; end
  end
end
