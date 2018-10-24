require_relative '../tax_management/tax_checker'
require_relative 'spec_helpers'

describe TaxChecker do

  context 'validate account' do

    it 'does not raise an exception when the credit and debit figures balance to the balance figure' do
      summary_array = [
        { account_name: 'test_account', account_balance: :dr, dr: 100, cr: 100, balance: 0 },
        { account_name: 'test_account', account_balance: :dr, dr: 200, cr: 100, balance: 100 },
        { account_name: 'test_account', account_balance: :dr, dr: 100, cr: 200, balance: -100 },
        { account_name: 'test_account', account_balance: :cr, dr: 100, cr: 100, balance: 0 },
        { account_name: 'test_account', account_balance: :cr, dr: 200, cr: 100, balance: -100 },
        { account_name: 'test_account', account_balance: :cr, dr: 100, cr: 200, balance: 100 },
      ]
      expect { TaxChecker.accounts_summary_validation(summary_array) }.not_to raise_error
    end

    it 'returns an exception when the specified dr, cr and balance are mismatched for a dr account' do
      summary_array = [
        { account_name: 'test_account', account_balance: :dr, dr: 100, cr: 100, balance: 1 }
      ]
      error_message = "summary validation failed for account 'test_account'"
      expect { TaxChecker.accounts_summary_validation(summary_array) }.to raise_error(error_message)
    end

    it 'returns an exception when the specified dr, cr and balance are mismatched for a dr account' do
      summary_array = [
        { account_name: 'test_account', account_balance: :cr, dr: 100, cr: 100, balance: 1 }
      ]
      error_message = "summary validation failed for account 'test_account'"
      expect { TaxChecker.accounts_summary_validation(summary_array) }.to raise_error(error_message)
    end

  end

  context 'get accounts balance hash' do

    it 'returns a hash of the assets, liabilities and equity balances' do
      expected = { assets: -150, equity: -60, liabilities: 250 }
      summary_array = TaxCheckerSpecHelpers.simple_unbalanced_accounts_array
      result = TaxChecker.accounts_balances_hash(summary_array)
      expect(result).to eq(expected)
    end

  end

end