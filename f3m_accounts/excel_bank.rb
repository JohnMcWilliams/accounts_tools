require_relative 'excel'
require 'awesome_print'

class ExcelBank < Excel
  def initialize(file_path)
    import_file_contents file_path

  row_hashes = []
    count = 0
    while @file_contents.sheets[count]
      @file_contents.sheets[count].rows.each do |row|
        row_hash = get_row_hash row
        row_hashes << row_hash
      end
      count = count + 1
    end
    awesome_print row_hashes

    # row = @file_contents.sheets[0].rows[0]
    # awesome_print get_row_hash row
  end

  def get_row_hash(row)
    {
        account_code: row[0],
        date:         row[1],
        bank_info:    row[2],
        amount:       row[3],
        sub_code:     row[4],
        memo:         row[5]
    }
  end
end