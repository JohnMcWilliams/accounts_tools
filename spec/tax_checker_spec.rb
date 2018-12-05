require_relative '../tax_management/tax_checker'
require_relative 'spec_helper'
require_relative 'support/reports_summary_spec_helpers'

describe TaxChecker do

  context 'draw in inputs from file' do

    it 'reads input figures for calculations' do
      result = TaxChecker.calculation_inputs
      expect(result).to be_a(Array)
      result.each_with_index do |item, i|
        expect(item).to be_a(Hash)
        expect(item.keys.sort).to eq(%w[period no_of_shares share_value PS12D S5B S22B].sort)
        item.values.each { |value| expect(value).to be_a(Fixnum) }
        expect(item['period']).to eq(i + 1)
      end
    end

  end

  context 'when generating outputs' do

    it 'should generate a reports summary' do
      expected = ReportsSummarySpecHelpers.full_reports_summary_balanced_output
      # ap expected[:previous][:accounts].map { |item| "#{item[:account_code]} - #{item[:dr]}, #{item[:cr]}, #{item[:balance]}" }
      inputs = {current: TaxCheckerSpecHelpers.inputs_hash, previous: TaxCheckerSpecHelpers.inputs_hash}
      actual = TaxChecker.generate_reports_summary(4, inputs)
      TaxCheckerSpecHelpers.verify_reports_summary(self, actual, expected)
    end

  end

end