require_relative 'tax_management/tax_checker'
require 'awesome_print'

ap TaxChecker.generate_reports_summary(7)
