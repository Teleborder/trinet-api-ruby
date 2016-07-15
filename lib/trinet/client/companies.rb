module Trinet
  class Client
    module Companies
      def company_details(company_id, options = nil)
        get "manage-company/#{company_id}/org-details", options
      end
    end
  end
end
