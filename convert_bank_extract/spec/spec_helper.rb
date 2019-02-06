ENV['RUN_ENV'] = 'test'
ENV['TOOL_ROOT'] = 'convert_bank_extract/'

require_relative '../../env'

require_relative 'support/convert_bank_extract_spec_helpers'
require 'awesome_print'
require 'axlsx'
require 'rspec'
require 'simple_xlsx_reader'

# RSpec.configure do |config|
#   config.treat_symbols_as_metadata_keys_with_true_values = true
# end
