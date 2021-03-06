require_relative 'ledger_entry'

class Account

  attr_accessor(:entries)

  def initialize(args={})
    populate_account(args[:entries]) if args.has_key?(:entries)
  end

  def populate_account(entries)
    @entries = []
    entries.each do |entry|
      @entries << LedgerEntry.new(entry)
    end
  end

  def self.accounts
    {
        cash:                     'A1. Cash',
        ar:                       'A2. AR',
        vat_payable:              'L1. VAT',
        ct_payable:               'L2. CT',
        salary_payable:           'L3. Salary',
        paye_payable:             'L4. PAYE',
        office_expenses_payable:  'L5. Office Expenses',
        misc_payable:             'L6. Misc',
        directors_loans_payable:  'L7. Directors\' Loans',
        capital:                  'E1. Capital',
        withdrawal:               'E2. Withdrawal',
        ct:                       'E3. CT',
        net_sales:                'E4. Net Sales',
        retained_vat:             'E5. Retained VAT',
        bank_expenses:            'E6. Bank Exp',
        travel_expenses:          'E7. Travel Exp',
        comms_expenses:           'E8. Comms Exp',
        sundry_expenses:          'E9. Sundry Exp',
        salary_expenses:          'E10. Salary',
        empee_tax_ni_expenses:    'E11. Emp\'ee tax & NI',
        emper_ni_expenses:        'E12. Emp\'er NI',
        fines_expenses:           'E13. Fines',
        co_house_expenses:        'E14. Co House',
        comms_office_expenses:    'E15. Office (Comms)',
        rent_office_expenses:     'E16. Office (Rent)',
        power_office_expenses:    'E17. Office (Power)',
        sundry_office_expenses:   'E18. Office (Sundry)'
    }
  end

end