module Pdf::Bidding
  class Edict::TemplateObraHtml
    include Call::Methods
    include ActionView::Helpers::NumberHelper

    attr_accessor :html, :tables_content, :table, :table2

    def initialize(*args)
      super
      @html = template_data
      @tables_content = []
    end

    def main_method
      parse_html
    end

    private

    def parse_html
      return if bidding_not_able_to_generate?

      dictionary.each do |key, value|
        html.gsub!(key, value.to_s)
      end

      html
    end

    def dictionary
      {
        '@@cooperative_legal_representative_name@@' => cooperative_legal_representative_name,
        '@@number_covenant@@' => bidding.covenant.number,
        '@@name_cooperative@@' => cooperative.name,
        '@@title_bidding@@' => bidding.title,
        "@@bidding_description@@" => bidding.description ,
        "@@bidding_link@@" => bidding.link ,
        "@@bidding_start_date@@" => bidding.start_date ,
        '@@project_name@@' => bidding.organization.name,
        '@@bidding_country@@' => bidding.organization.country,
        '@@cooperative.name@@' => cooperative.name,
        '@@cooperative.address.address@@' => cooperative.address.address,
        '@@cooperative.address.city.name@@' => cooperative.address.city.name,
        '@@cooperative.address.city.state.name@@' =>
          cooperative.address.city.state.name,
        '@@cooperative.cnpj@@' => cooperative.cnpj,
        '@@cooperative_legal_representative_email@@' => cooperative.legal_representative.email,
        '@@cooperative.legal_representative.name@@' =>
          cooperative.legal_representative.name,
        '@@bidding.title@@' => bidding.title,
        '@@bidding.items@@' => bidding_items,
        '@@bidding.proposals@@' => fill_tables,
        '@@current_date@@' => format_date(Date.current),
        '@@technical_team@@' => fill_table_technical_team,
        "@@contract_annex@@" => pre_contract_render,
        '@@bidding.closing_date@@' => format_date(bidding.closing_date),
        '@@deadline_lot@@' => format_date(bidding.closing_date),
      }
    end

    def cooperative_legal_representative_name
      legal_representative(cooperative).name
    end

    def legal_representative(klass)
      klass.legal_representative
    end

    def bidding_items
      bidding.lot_group_items.map(&:item).map(&:title).uniq.to_sentence
    end

    def fill_tables
      bidding.lots.each do |lot|
        tables_content.push(fill_title(lot))
        tables_content.push(fill_table(lot))
      end

      to_text(tables_content)
    end

    def fill_title(lot)
      "<p class=\"tab50\"><b>#{I18n.t("document.pdf.bidding.edict.lot")}: #{lot.name}</b></p>"
    end

    def fill_table(lot)
      @table = []

      fill_table_top_row(lot)

      lot.lot_group_items.each do |lot_group_item|
        fill_table_row(lot_group_item)
      end

      surrond_with_table_tag
      to_text(table)
    end

    def fill_table_top_row(lot)
      table.push(
        "<tr>"\
          "<th>#{I18n.t("document.pdf.bidding.edict.table.header.item_title")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.edict.table.header.item_description")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.edict.table.header.item_classification")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.edict.table.header.item_quantity")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.edict.table.header.item_unit")}</th>"\
        "</tr>"
      )
    end

    def fill_table_row(lot_group_item)
      table.push(
        "<tr>"\
          "<td>#{lot_group_item.item.title}</td>"\
          "<td>#{lot_group_item.item.description}</td>"\
          "<td>#{lot_group_item.classification.name}</td>"\
          "<td>#{formatted_number(lot_group_item.quantity)}</td>"\
          "<td>#{lot_group_item.item.unit_name}</td>"\
        "</tr>"
      )
    end

    def fill_table_technical_team
      @table2 = []
      table2.push(
        "<tr>"\
          "<th>#{I18n.t("document.pdf.bidding.edict.table.header.professional")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.edict.table.header.quantity")}</th>"\
        "</tr>"
      )
      table2.push(
        "<tr>"\
          "<td>Eng.º Civil ou Arquiteto</td>"\
          "<td>01</td>"\
        "</tr>"
      )
      table2.push(
        "<tr>"\
          "<td>Encarregado Geral</td>"\
          "<td>01</td>"\
        "</tr>"
      )
      table2.unshift("<table>")
      table2.push("</table><br/>")
      to_text(table2)
    end

    def surrond_with_table_tag
      table.unshift("<table>")
      table.push("</table><br/>")
    end

    def to_text(array)
      array.join("")
    end

    def cooperative
      @cooperative ||= bidding.cooperative
    end

    def format_date(date)
      date.strftime("%d/%m/%Y")
    end

    def formatted_number(value)
      number_with_delimiter(value)
    end

    def bidding_not_able_to_generate?
      !(bidding.approved? || bidding.ongoing?)
    end

    def template_data
      append = bidding.organization.locale == "pt-BR" ? "_obra" : ""
      @template_data ||=
        File.read(
          Rails.root.join('lib', 'pdf', 'bidding', 'edict', 'templates', "edict#{append}.#{bidding.organization.locale}.html")
        )
    end

    def pre_contract_render
      c = Pdf::Contract::TemplateStrategy.decideByClassificationName(className: bidding.classification_name, contract: nil, bidding: bidding)
      c.call
    end
  end
end
