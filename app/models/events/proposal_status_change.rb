class Events::ProposalStatusChange < Event
  data_attr :from, :to, :comment

  validates :to, :from, inclusion: { in: Proposal.statuses.keys }

  validates :comment, presence: true, if: :needs_comment?

  def self.changing_to(status)
    # flexibilizing table name
    # @see https://github.com/rails/arel/issues/288#issuecomment-64015191
    #
    where Arel.sql("JSON_EXTRACT(events.data, '$.to', '"+status+"')")
  end

  private

  def needs_comment?
    to == 'coop_refused'
  end
end
