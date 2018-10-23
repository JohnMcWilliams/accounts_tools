module SummaryCalculations

  def self.report_calculations(period, summary)
    initial_calculation_data.each_with_object([]) do |(key, value), a|
      a << { key => { name: value[:name] }.merge(calculation(summary, value[:accounts], value[:balance_type])) }
    end
  end

  def self.calculation(summary, accounts, balance_type)
    dr_cr = accounts.each_with_object({ dr: 0, cr: 0 }) do |account, h|
      h[:dr] += account_balance(summary, account, :dr)
      h[:cr] += account_balance(summary, account, :cr)
    end
    balance = {
      dr: dr_cr[:dr] - dr_cr[:cr],
      cr: dr_cr[:cr] - dr_cr[:dr]
    }[balance_type]
    dr_cr.merge(balance: balance)
  end

  def self.account_balance(summary, account, key)
    account_hash = summary.find { |item| item[:account_code] == account }
    raise("no account found for #{account}") unless account_hash
    account_hash[key]
  end

  def self.initial_calculation_data
    {
      'S1' => { name: 'Total Comms Exp', accounts: %w[E8 E15], balance_type: :dr},
      'S2' => { name: 'Total Sundry Exp', accounts: %w[E9 E18], balance_type: :dr},
      'S3' => { name: 'Total PAYE Exp', accounts: %w[E11 E12], balance_type: :dr},
      'S4' => { name: 'A/P excl VAT', accounts: ('L2'..'L7').to_a, balance_type: :cr},
      'S9' => { name: 'Total Revenue', accounts: %w[E4 E5], balance_type: :cr },
      'S10' => { name: 'Total Expenses', accounts: ('E6'..'E18').to_a, balance_type: :dr },
      'S17' => { name: 'Total Liabilities', accounts: ('L1'..'L7').to_a, balance_type: :cr},
      'S19' => { name: 'Admin & Office Exp', accounts: ['E8'] + ('E13'..'E16').to_a, balance_type: :dr}
    }
  end

end