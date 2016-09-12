module Trinet
  class Client
    module Employees
      def all_employees(company_id, options = nil)
        get "company/#{company_id}/employees", options
      end

      def employee_details(company_id, employee_id)
        get "identity/#{company_id}/#{employee_id}/biographical-details"
      end

      def employee_roles(company_id, employee_id)
        employees = all_employees company_id, { "viewType" => "all" }
        employees["employeeData"].each do |e|
          return e["roles"] if e["employeeId"] == employee_id
        end
        raise "#{employee_id} not found in company #{company_id}"
      end
    end
  end
end
