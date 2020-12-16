module Pdf::Builder
  class OrderService < Base
    private

    def cooperative
      @cooperative ||= contract.bidding.cooperative
    end

    def contract
      header_resource
    end

    def options
      { margin_left:'0in',margin_right:'0in', margin_top:'0in'  }
    end
  end
end
