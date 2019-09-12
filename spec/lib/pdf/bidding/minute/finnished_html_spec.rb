require 'rails_helper'

RSpec.describe Pdf::Bidding::Minute::FinnishedHtml do
  let(:params) { { bidding: bidding } }

  describe '#initialize' do
    let(:bidding) { create(:bidding) }

    subject { described_class.new(params) }

    it { expect(subject.bidding).to eq(bidding) }
    it { expect(subject.html).to be_present }
  end

  describe '.call' do
    subject { described_class.call(params) }

    context 'when able to generate' do
      let(:provider) { create(:provider, type: 'Provider') }
      let(:supplier) { create(:supplier, provider: provider) }
      let(:covenant) { create(:covenant) }
      let(:group) { covenant.groups.first }
      let(:admin) { create(:admin) }

      let(:item_2) { create(:item, title: 'Cimento', description: 'Cimento fino', owner: admin) }
      let(:item_3) { create(:item, title: 'Tonner', description: 'Tonner cor preta', owner: admin) }

      let(:group_item_1) { covenant.group_items.first }
      let(:group_item_3) { create(:group_item, group: group, item: item_3) }
      let(:group_item_2) { create(:group_item, group: group, item: item_2) }

      # generic attributes
      let(:lot_base) { { build_lot_group_item: false, status: :accepted } }
      let(:proposal_status) { { status: :accepted } }
      let(:proposal_base_1) { proposal_status.merge(bidding: bidding, provider: provider) }
      let(:proposal_base_2) { proposal_status.merge(bidding: bidding, provider: provider) }

      # lot 1
      let(:lot_group_item_1) { create(:lot_group_item, group_item: group_item_1) }
      let(:lot_group_item_2) { create(:lot_group_item, group_item: group_item_2) }
      let(:lot_group_item_3) { create(:lot_group_item, group_item: group_item_3) }

      let(:lot_1) do
        create(:lot, lot_base.merge(lot_group_items: [lot_group_item_1, lot_group_item_2, lot_group_item_3]))
      end

      let(:proposal_1) { create(:proposal, proposal_base_1) }
      let(:lot_group_item_lot_proposal_1) { create(:lot_group_item_lot_proposal, lot_group_item: lot_group_item_1) }
      let(:lot_group_item_lot_proposal_2) { create(:lot_group_item_lot_proposal, lot_group_item: lot_group_item_2) }
      let(:lot_group_item_lot_proposal_3) { create(:lot_group_item_lot_proposal, lot_group_item: lot_group_item_3) }
      let!(:lot_proposal_1) do
        create(:lot_proposal, build_lot_group_item_lot_proposal: false, lot: lot_1, proposal: proposal_1,
                              supplier: supplier,
                              lot_group_item_lot_proposals: [
                                lot_group_item_lot_proposal_1,
                                lot_group_item_lot_proposal_2,
                                lot_group_item_lot_proposal_3
                              ])
      end

      # lot 2
      let(:lot_group_item_4) { create(:lot_group_item, group_item: group_item_1) }
      let(:lot_group_item_5) { create(:lot_group_item, group_item: group_item_2) }
      let(:lot_group_item_6) { create(:lot_group_item, group_item: group_item_3) }

      let(:lot_2) do
        create(:lot, lot_base.merge(lot_group_items: [lot_group_item_4, lot_group_item_5, lot_group_item_6]))
      end

      let(:proposal_2) { create(:proposal, proposal_base_1) }
      let(:lot_group_item_lot_proposal_4) { create(:lot_group_item_lot_proposal, lot_group_item: lot_group_item_1) }
      let(:lot_group_item_lot_proposal_5) { create(:lot_group_item_lot_proposal, lot_group_item: lot_group_item_2) }
      let(:lot_group_item_lot_proposal_6) { create(:lot_group_item_lot_proposal, lot_group_item: lot_group_item_3) }
      let!(:lot_proposal_2) do
        create(:lot_proposal, build_lot_group_item_lot_proposal: false, lot: lot_2, proposal: proposal_2,
                              supplier: supplier,
                              lot_group_item_lot_proposals: [
                                lot_group_item_lot_proposal_4,
                                lot_group_item_lot_proposal_5,
                                lot_group_item_lot_proposal_6
                              ])
      end

      let!(:bidding) { create(:bidding, build_lot: false, lots: [lot_1, lot_2], kind: kind, status: :finnished) }
      let(:kind) { :global }

      context 'when is global' do
        let(:file_type) { 'minute_finnished_global' }

        it { is_expected.not_to include("@@") }
      end

      context 'when is lot' do
        let(:kind) { :lot }
        let(:file_type) { 'minute_finnished_lot' }

        it { is_expected.not_to include("@@") }
      end

      context 'when there are invites' do
        let(:user_1) { create(:supplier) }
        let(:provider_1) { user_1.provider }
        let!(:invite_1) { create(:invite, bidding: bidding, provider: provider_1, status: :approved) }
        let(:user_2) { create(:supplier) }
        let(:provider_2) { user_2.provider }
        let!(:invite_2) { create(:invite, bidding: bidding, provider: provider_2, status: :approved) }
        let(:file_type) { 'minute_finnished_invites' }

        it { is_expected.not_to include("@@") }
      end

      context 'when there are comments' do
        let!(:event_proposal_status_changes) { create(:event_proposal_status_change, eventable: proposal_1) }
        let!(:event_cancel_proposal_accepteds) { create(:event_cancel_proposal_accepted, eventable: proposal_1) }
        let!(:event_cancel_proposal_refuseds) { create(:event_cancel_proposal_refused, eventable: proposal_2) }
        let(:file_type) { 'minute_finnished_comments' }

        it { is_expected.not_to include("@@") }
      end

      context 'when threre are draft proposals' do
        let(:file_type) { 'minute_finnished_global' }
        let(:service_build) { described_class.new(params) }

        before do
          allow(service_build).to receive(:proposal_line).and_return('')
          proposal_1.draft!
          proposal_2.draft!
          service_build.call
        end

        it { expect(service_build).not_to have_received(:proposal_line) }
      end

      after do
        File.write(
          Rails.root.join("spec/fixtures/myfiles/#{file_type}_template.html"),
          subject
        )
      end
    end

    context 'when not able to generate' do
      let(:bidding) { create(:bidding, status: :draft) }

      it { is_expected.to be_nil }
    end
  end
end
