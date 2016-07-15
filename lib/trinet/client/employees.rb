module Trinet
  class Client
    module Employees
      def all_employees(company_id, options = nil)
        get "company/#{company_id}/employees", options
      end

      def employee_details(company_id, employee_id)
        get "identity/#{company_id}/#{employee_id}/biographical-details"
      end
    end
  end
end
