class JournalTransaction

  attr_accessor(:journal_entries, :date, :description, :pattern_name)

  def initialize(args={})
    @journal_entries = []
    if args.has_key?(:journal_entries)
        if args[:journal_entries].is_a?(Array)
            @journal_entries.concat(args[:journal_entries])
        else
            @journal_entries << args[:journal_entries]
        end
    end
    @date = args[:date] if args.has_key?(:date)
    @description = args[:description] if args.has_key?(:description)
    @pattern_name = args[:pattern_name] if args.has_key?(:pattern_name)
  end

  def self.transaction_patterns
    {
        issue_invoice: {
            ar:                       :dr,
            vat_payable:              :cr,
            net_sales:                :cr,
        },
        issue_invoice_flat_rate: {
            ar:                       :dr,
            vat_payable:              :cr,
            net_sales:                :cr,
            retained_vat:             :cr
        },
        receive_remittance: {
            cash:                     :dr,
            ar:                       :cr
        },
        owner_investment: {
            cash:                     :dr,
            capital:                  :cr
        },
        pay_vat: {
            vat_payable:              :dr,
            cash:                     :cr
        },
        pay_corporation_tax: {
            ct_payable:               :dr,
            cash:                     :cr
        },
        employee_works: {
            salary_expenses:          :dr,
            empee_tax_ni_expenses:    :dr,
            emper_ni_expenses:        :dr,
            salary_payable:           :cr,
            paye_payable:             :cr
        },
        pay_salary: {
            salary_payable:           :dr,
            cash:                     :cr
        },
        pay_paye: {
            paye_payable:             :dr,
            cash:                     :cr
        },
        accrue_comms_office_expenses: {
            comms_office_expenses:    :dr,
            office_expenses_payable:  :cr
        },
        accrue_rent_office_expenses: {
            rent_office_expenses:     :dr,
            office_expenses_payable:  :cr
        },
        accrue_power_office_expenses: {
            power_office_expenses:    :dr,
            office_expenses_payable:  :cr
        },
        accrue_sundry_office_expenses: {
            sundry_office_expenses:   :dr,
            office_expenses_payable:  :cr
        },
        pay_office_expenses: {
            office_expenses_payable:  :dr,
            cash:                     :cr
        },
        pay_misc_payable: {
            misc_payable:             :dr,
            cash:                     :cr
        },
        bank_payments: {
            bank_expenses:            :dr,
            cash:                     :cr
        },
        travel_payments: {
            travel_expenses:          :dr,
            cash:                     :cr
        },
        comms_payments: {
            comms_expenses:           :dr,
            cash:                     :cr
        },
        sundry_payments: {
            sundry_expenses:          :dr,
            cash:                     :cr
        },
        sundry_refunds: {
            cash:                     :dr,
            sundry_expenses:          :cr
        },
        fines_payments: {
            fines_expenses:           :dr,
            cash:                     :cr
        }
    }
  end

end