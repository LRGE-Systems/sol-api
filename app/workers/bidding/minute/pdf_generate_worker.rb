class Bidding::Minute::PdfGenerateWorker
  include Sidekiq::Worker

  sidekiq_options retry: 5

  def perform(bidding_id, contract=nil)
    puts "CONTRACT!!"
    puts contract

    bidding = Bidding.find(bidding_id).reload
    unless contract.blank?
      puts "CONTRACT ID"
      puts contract['id']
      Contract.find(contract["id"]).update(contract)
      puts "UPDATED!"
      bidding.reload
      bidding.contracts.reload
    end
    puts "CARAIO!!"
    BiddingsService::Minute::PdfGenerate.call!(bidding: bidding)
  end
end
