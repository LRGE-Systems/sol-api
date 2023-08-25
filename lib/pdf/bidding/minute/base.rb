module Pdf::Bidding
  class Minute::Base
    include Call::Methods
    include ActionView::Helpers::NumberHelper
    include Pdf::HelperMethods

    attr_accessor :html, :tables_content, 
    :tables_prop_content, :tables_prop_coop_content, 
    :tables_prop_admin_content, :tables_prop_contract_content,
    :tables_prop_contract_terminated_content, :table

    def initialize(*args)
      super
      @html = template_data
      @tables_content = []
      @tables_prop_content = []
      @tables_prop_coop_content = []
      @tables_prop_admin_content = []
      @tables_prop_contract_content = []
      @tables_prop_contract_terminated_content = []
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
      
      puts "HTML MADE"
      
      html
    end

    def dictionary
      {
        "@@bidding_description@@" => bidding.description ,
        '@@title_bidding@@' => bidding.title,
        "@@bidding_start_date@@" => bidding.start_date ,
        '@@bidding_country@@' => bidding.organization.country,
        '@@project_name@@' => bidding.organization.name,
        '@@name_cooperative@@' => cooperative.name,
        '@@number_covenant@@' => bidding.covenant.number,
        '@@items_lot@@' => fill_tables,
        '@@proposals_items@@'=> fill_proposals_tables,
        '@@items_proposals_coop@@' => fill_proposals_coop_tables,
        '@@items_proposals_admin@@' => fill_proposals_admin_tables,
        '@@contract_all_signed@@' => fill_contract_signed_tables,
        '@@contract_all_terminated@@' => fill_contract_terminated_tables,
        '@@cooperative.name@@' => cooperative.name,
        '@@cooperative.address.address@@' => cooperative.address.address,
        '@@cooperative.address.city.name@@' => cooperative.address.city.name,
        '@@cooperative.address.city.state.name@@' => cooperative.address.city.state.name,
        '@@cooperative.cnpj@@' => cooperative.cnpj,
        '@@cooperative.legal_representative.name@@' => cooperative.legal_representative.name,
        '@@covenant.number@@' => covenant_number(bidding.covenant.number),
        '@@bidding.title@@' => bidding.title,
        '@@bidding.description@@' => bidding.description,
        '@@bidding.closing_date@@' => format_date(bidding.closing_date),
        '@@invite.suppliers.sentence@@' => invite_suppliers_sentence,
        '@@invite.suppliers.provider_sentence@@' => invite_suppliers_provider_sentence,
        '@@bidding.lot_proposals.providers@@' => bidding_lot_proposals_providers,
        '@@bidding.proposals.sentence@@' => bidding_proposals_sentence,
        '@@bidding.proposals.accepted@@' => bidding_proposals_accepted,
        '@@bidding.comments.sentence@@' => bidding_comments_sentence,
        '@@failure_event.comment@@' => failure_event_comment,
        '@@env_covenant_resource@@' => pdf_minute_env('COVENANT_RESOURCE')
      }
    end

    def covenant_number(number)
      "#{number[0..3]}/#{number[4..5]}"
    end

    def invite_suppliers_sentence
      return if bidding.invites.blank?

      I18n.t('document.pdf.bidding.minute.invites_providers') +
      bidding.invites.inject([]) do |array, invite|
        array << provider_sentence(invite)
      end.uniq.to_sentence + '.'
    end

    def invite_suppliers_provider_sentence
      return if bidding.invites.blank?

      bidding.invites.inject([]) do |array, invite|
        array << provider_sentence(invite)
      end.uniq.to_sentence + '.'
    end

    def bidding_lot_proposals_providers
      I18n.t('document.pdf.bidding.minute.proposals_providers') +
      bidding.lot_proposals.active_and_orderly.inject([]) do |array, lot_proposal|
        array << provider_sentence(lot_proposal)
      end.uniq.to_sentence + '.'
    end

    def provider_sentence(object)
      I18n.t('document.pdf.bidding.minute.provider_sentence') %
        [object.provider.name, object.provider.document]
    end

    def bidding_proposals_sentence
      if bidding.global?
        global_text + proposals_sentence(bidding.proposals) + '.'
      else
        bidding.lots.inject(['<p>']) do |array, lot|
          array << lot_text(lot) + proposals_sentence(lot.proposals) + '.'
        end.join('</p>')
      end
    end

    def global_text
      I18n.t('document.pdf.bidding.minute.global_text') % bidding.title
    end

    def lot_text(lot)
      I18n.t('document.pdf.bidding.minute.lot_text') % [lot.position, lot.name]
    end

    def proposals_sentence(proposals)
      proposals.active_and_orderly.inject([]) do |array, proposal|
        array << proposal_line(proposal)
      end.to_sentence
    end

    def proposal_line(proposal)
      proposal_value = format_currency(proposal.price_total)
      proposal_value_prepared = prepare_currency(proposal_value)

      if valid_value_for_full_text?(proposal_value_prepared)
        proposal_text = Extenso.moeda(proposal_value_prepared)

        I18n.t('document.pdf.bidding.minute.proposal_line') %
          [proposal.provider.name, proposal_value, proposal_text]
      else
        I18n.t('document.pdf.bidding.minute.proposal_line_without_text_value') %
          [proposal.provider.name, proposal_value]
      end

    end

    def bidding_proposals_accepted
      if bidding.global?
        global_text + proposal_accepted(bidding.proposals)
      else
        bidding.lots.inject(['<p>']) do |array, lot|
          array << lot_text(lot) + proposal_accepted(lot.proposals)
        end.join('</p>')
      end
    end

    def proposal_accepted(proposals)
      proposal = proposals.where(status: :accepted).first

      return I18n.t('document.pdf.bidding.minute.no_proposals') if proposal.blank?

      proposal_value = format_currency(proposal.price_total)
      proposal_value_prepared = prepare_currency(proposal_value)

      if valid_value_for_full_text?(proposal_value_prepared)
        proposal_text = Extenso.moeda(proposal_value_prepared)

        I18n.t('document.pdf.bidding.minute.proposals_accepted') %
          [proposal.provider.name, proposal.provider.document, proposal_value, proposal_text]
      else
        I18n.t('document.pdf.bidding.minute.proposals_accepted_without_text_value') %
          [proposal.provider.name, proposal.provider.document, proposal_value]
      end
    end

    def bidding_comments_sentence
      final_comments = []

      bidding_comments.group_by { |bc| bc[:provider_name] }.each do |provider_name, comments|
        comments.sort_by! { |comment| comment[:created_at] }

        final_comments.push(
          '<p>' +
          I18n.t('document.pdf.bidding.minute.bidding_comment_text') % provider_name +
          comments.inject([]) do |array, comment|
            array << "#{comment[:text]}, #{comment[:user_name]}"
          end.to_sentence +
          '</p>'
        )
      end

      final_comments.join
    end

    def bidding_comments
      bidding.proposals.inject([]) do |array, proposal|
        array << serialize_comments(proposal, proposal.event_proposal_status_changes)
        array << serialize_comments(proposal, proposal.event_cancel_proposal_accepteds)
        array << serialize_comments(proposal, proposal.event_cancel_proposal_refuseds)
      end.flatten
    end

    def serialize_comments(proposal, proposal_events)
      proposal_events.map do |event|
        {
          provider_name: proposal.provider.name,
          user_name: event.creator.name,
          text: event.data['comment'],
          created_at: event.created_at
        }
      end
    end

    def failure_event_comment
      return if bidding.event_bidding_failures.blank?

      bidding.event_bidding_failures.first.data['comment']
    end

    def cooperative
      @cooperative ||= bidding.cooperative
    end

    def prepare_currency(value)
      value.delete(',').delete('.').delete('R$ ').to_i
    end

    def format_currency(value)
      return if value.blank?

      number_to_currency(value)
    end

    def format_date(date)
      date.strftime("%d/%m/%Y")
    end

    def template_data
      @template_data ||=
        File.read(
          Rails.root.join('lib', 'pdf', 'bidding', 'minute', 'templates', template_file_name)
        )
    end

    def pdf_minute_env(key)
      ENV["PDF_MINUTE_#{key}"]
    end

    # override
    def bidding_not_able_to_generate?; end

    # override
    def template_file_name; end

    def to_text(array)
      array.join("")
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
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.item_number")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.item_description")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.item_quantity")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.item_unit")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.item_destiny")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.item_destiny_deadline")}</th>"\
        "</tr>"
      )
    end

    def fill_table_row(lot_group_item)
      table.push(
        "<tr>"\
          "<td>#{lot_group_item.item.title}</td>"\
          "<td>#{lot_group_item.item.description}</td>"\
          "<td>#{formatted_number(lot_group_item.quantity)}</td>"\
          "<td>#{lot_group_item.item.unit_name}</td>"\
          "<td>#{lot_group_item.lot.address}</td>"\
          "<td>#{lot_group_item.lot.deadline}</td>"\
        "</tr>"
      )
    end

    def surrond_with_table_tag
      table.unshift("<table>")
      table.push("</table><br/>")
    end

    def formatted_number(value)
      number_with_delimiter(value)
    end

    ######

    def fill_proposals_tables

      bidding.lot_proposals.each_with_index do |lot, ind|
        tables_prop_content.push(fill_proposals_title(lot))
        tables_prop_content.push(fill_proposals_table(lot, ind))
      end

      to_text(tables_prop_content)
    end
    
    def fill_proposals_title(lot)
      ""
      # "<p class=\"tab50\"><b>#{I18n.t("document.pdf.bidding.edict.lot")}: #{lot.name}</b></p>"
    end

    def fill_table_proposals_top_row(lot)
      table.push(
        "<tr>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_item_lot")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_rank")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_name")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_id")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_price")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_date")}</th>"\
        "</tr>"
      )
    end

    def fill_proposals_table_row(lot, lot_group_item, ind)
      table.push(
        "<tr>"\
          "<td>#{lot_group_item.item.title}</td>"\
          "<td>#{ind+1}</td>"\
          "<td>#{lot.proposal.provider.name}</td>"\
          "<td>#{lot.proposal.provider.id}</td>"\
          "<td>#{lot.price_total}</td>"\
          "<td>#{I18n.l(lot_group_item.created_at, format: :shorter)}</td>"\
        "</tr>"
      )
    end

    def fill_proposals_table(lot, ind)
      @table = []

      fill_table_proposals_top_row(lot)

      lot.lot_group_items.each do |lot_group_item|
        fill_proposals_table_row(lot, lot_group_item, ind)
      end

      surrond_with_table_tag
      to_text(table)
    end


    ####

    def fill_proposals_coop_tables

      bidding.lot_proposals.each_with_index do |lot, ind|
        tables_prop_coop_content.push(fill_proposals_coop_title(lot))
        tables_prop_coop_content.push(fill_proposals_coop_table(lot, ind))
      end

      to_text(tables_prop_coop_content)
    end
    
    def fill_proposals_coop_title(lot)
      ""
      # "<p class=\"tab50\"><b>#{I18n.t("document.pdf.bidding.edict.lot")}: #{lot.name}</b></p>"
    end

    def fill_table_proposals_coop_top_row(lot)
      table.push(
        "<tr>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_item_lot")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_rank")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_name")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_id")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_accepted_yn")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_reject_reason")}</th>"\
        "</tr>"
      )
    end

    def fill_proposals_coop_table_row(lot, lot_group_item, ind)
      if lot.blank? || lot.proposal.blank?
        "NODEF"
      else 
        comment = lot.proposal.event_proposal_status_changes.filter{|e| e.to == 'coop_refused'}.last.comment
        table.push(
          "<tr>"\
            "<td>#{lot_group_item.item.title}</td>"\
            "<td>#{ind}</td>"\
            "<td>#{lot.proposal.provider.name}</td>"\
            "<td>#{lot.proposal.provider.id}</td>"\
            "<td>#{I18n.t("document.pdf.bidding.minute.table.header.#{lot.proposal.coop_accepted? ? 'prop_yes' : lot.proposal.coop_refused? ? 'prop_no' : 'prop_triage'}")}</td>"\
            "<td>#{comment}</td>"\
          "</tr>"
        )
      end
    end

    def fill_proposals_coop_table(lot, ind)
      @table = []

      fill_table_proposals_coop_top_row(lot)

      lot.lot_group_items.each do |lot_group_item|
        fill_proposals_coop_table_row(lot, lot_group_item, ind)
      end

      surrond_with_table_tag
      to_text(table)
    end

    ###

    def fill_proposals_admin_tables

      bidding.lot_proposals.each_with_index do |lot, ind|
        tables_prop_admin_content.push(fill_proposals_admin_title(lot))
        tables_prop_admin_content.push(fill_proposals_admin_table(lot, ind))
      end

      to_text(tables_prop_admin_content)
    end
    
    def fill_proposals_admin_title(lot)
      ""
      # "<p class=\"tab50\"><b>#{I18n.t("document.pdf.bidding.edict.lot")}: #{lot.name}</b></p>"
    end

    def fill_table_proposals_admin_top_row(lot)
      table.push(
        "<tr>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_item_lot")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_contract_number")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_name")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_id")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_awarded_on")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_awarded_amount")}</th>"\
        "</tr>"
      )
    end

    def fill_proposals_admin_table_row(lot, lot_group_item, ind)
      if lot.blank? || lot.proposal.blank? || lot.proposal.contract.blank?
        "NODEF"
      else 
        table.push(
          "<tr>"\
            "<td>#{lot_group_item.item.title}</td>"\
            "<td>#{lot.proposal.contract.title}</td>"\
            "<td>#{lot.proposal.provider.name}</td>"\
            "<td>#{lot.proposal.provider.id}</td>"\
            "<td>#{I18n.l(lot.proposal.contract.created_at, format: :shorter)}</td>"\
            "<td>#{lot.proposal.price_total}</td>"\
          "</tr>"
        )
      end
    end

    def fill_proposals_admin_table(lot, ind)
      @table = []

      fill_table_proposals_admin_top_row(lot)

      lot.lot_group_items.each do |lot_group_item|
        fill_proposals_admin_table_row(lot, lot_group_item, ind)
      end

      surrond_with_table_tag
      to_text(table)
    end


    ###

    def fill_contract_signed_tables

      bidding.contracts.each_with_index do |contract, ind|
        contract.proposal.lot_proposals.each_with_index do |lot, ind|
          tables_prop_contract_content.push(fill_contract_signed_title(lot))
          tables_prop_contract_content.push(fill_contract_signed_table(lot, ind))
        end
      end

      to_text(tables_prop_contract_content)
    end
    
    def fill_contract_signed_title(lot)
      ""
      # "<p class=\"tab50\"><b>#{I18n.t("document.pdf.bidding.edict.lot")}: #{lot.name}</b></p>"
    end

    def fill_table_contract_signed_top_row(lot)
      table.push(
        "<tr>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_item_lot")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_contract_number")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_name")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_id")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_signed_on")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_rejected_on")}</th>"\
        "</tr>"
      )
    end

    def fill_contract_signed_table_row(lot, lot_group_item, ind)
      if  lot.blank? || lot.proposal.blank? || lot.proposal.contract.blank?
        "NODEF"
      else 
        allsigned = lot.proposal.contract.all_signed? ? I18n.l(lot.proposal.contract.updated_at, format: :shorter) : ''
        rejected = lot.proposal.contract.refused? ? I18n.l(lot.proposal.contract.updated_at, format: :shorter) : ''
        table.push(
          "<tr>"\
            "<td>#{lot_group_item.item.title}</td>"\
            "<td>#{lot.proposal.contract.title}</td>"\
            "<td>#{lot.proposal.provider.name}</td>"\
            "<td>#{lot.proposal.provider.id}</td>"\
            "<td>#{allsigned}</td>"\
            "<td>#{rejected}</td>"\
          "</tr>"
        )
      end
    end

    def fill_contract_signed_table(lot, ind)
      @table = []

      fill_table_contract_signed_top_row(lot)

      lot.lot_group_items.each do |lot_group_item|
        fill_contract_signed_table_row(lot, lot_group_item, ind)
      end

      surrond_with_table_tag
      to_text(table)
    end


    ###

    def fill_contract_terminated_tables

      bidding.contracts.each_with_index do |contract, ind|
        contract.proposal.lot_proposals.each_with_index do |lot, ind|
          tables_prop_contract_terminated_content.push(fill_contract_terminated_title(lot))
          tables_prop_contract_terminated_content.push(fill_contract_terminated_table(lot, ind))
        end
      end

      to_text(tables_prop_contract_terminated_content)
    end
    
    def fill_contract_terminated_title(lot)
      ""
      # "<p class=\"tab50\"><b>#{I18n.t("document.pdf.bidding.edict.lot")}: #{lot.name}</b></p>"
    end

    def fill_table_contract_terminated_top_row(lot)
      table.push(
        "<tr>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_item_lot")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_contract_number")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_name")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_bidder_id")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_completed_on")}</th>"\
          "<th>#{I18n.t("document.pdf.bidding.minute.table.header.prop_awarded_amount")}</th>"\
        "</tr>"
      )
    end

    def fill_contract_terminated_table_row(lot, lot_group_item, ind)
      if  lot.blank? || lot.proposal.blank? || lot.proposal.contract.blank?
        "NODEF"
      else 
        table.push(
          "<tr>"\
            "<td>#{lot_group_item.item.title}</td>"\
            "<td>#{lot.proposal.contract.title}</td>"\
            "<td>#{lot.proposal.provider.name}</td>"\
            "<td>#{lot.proposal.provider.id}</td>"\
            "<td>#{I18n.l(lot.proposal.contract.updated_at, format: :shorter)}</td>"\
            "<td>#{lot.proposal.price_total}</td>"\
          "</tr>"
        )
      end
    end

    def fill_contract_terminated_table(lot, ind)
      @table = []

      fill_table_contract_terminated_top_row(lot)

      lot.lot_group_items.each do |lot_group_item|
        fill_contract_terminated_table_row(lot, lot_group_item, ind)
      end

      surrond_with_table_tag
      to_text(table)
    end

  end
end
