require_relative 'spec_helper'
require_relative '../lib/convert_bank_extract'

describe 'ConvertBankExtract' do

  before(:each) do
    ConvertBankExtractSpecHelpers.restore_test_state(state: :setup)
  end

  after(:each) do
    ConvertBankExtractSpecHelpers.restore_test_state
  end

  context 'integration tests' do

    it 'builds a write hash' do
      write_hash = ConvertBankExtract.build_write_hash
      expect(write_hash.keys).to eq(['bank', :formats])
      expect(write_hash['bank']).to be_a(Array)
      expect(write_hash[:formats].keys).to eq(['bank'])
      expect(write_hash[:formats]['bank'].keys).to eq([:headers, 'A', 'D', 'E', 'F', 'G'])
    end

    it 'saves an excel file built from csv data' do
      ConvertBankExtract.convert_bank_extract
      workbook = Rxl.read_file_as_tables(CONFIG['bank_book_filepath'])
      expect(workbook.keys).to eq(['bank'])
      expect(workbook['bank'].count).to eq(16)
      expect(workbook['bank'][0]['id']).to eq(1)
      expect(workbook['bank'][-1]['id']).to eq(16)
      archive_filename = ConvertBankExtractSpecHelpers.dir_filenames(CONFIG['bookkeeping_archive_path'])[0]
      archive = Rxl.read_file_as_tables("#{CONFIG['bookkeeping_archive_path']}#{archive_filename}")
      expect(archive.keys).to eq(['bank'])
      expect(archive['bank'].count).to eq(13)
      expect(archive['bank'][-1]['id']).to eq(13)
    end

  end

  context 'unit tests' do

    context 'import files to memory' do

      it 'loads the current bank book file into memory' do
        file = ConvertBankExtract.load_file(:bank_book)
        expect(file.class).to be(Array)
        expect(file[0].keys).to eq(%w[id period statement date debit credit balance subcat description])
        expect(file[0]['date']).to be_a(DateTime)
      end

      it 'loads the CSV file into memory' do
        file = ConvertBankExtract.load_file(:csv)
        expect(file.class).to be(Array)
        file.each do |row|
          expect(row[1]).to match(/^\d\d\/\d\d\/\d\d\d\d$/)
          expect(row[2]).to match(/^\d\d-\d\d-\d\d\s\d\d\d\d\d\d\d\d$/)
          expect(row[3]).to match(/^-?\d+\.\d\d$/)
          expect(row[4]).to be_a(String)
          expect(row[4]).not_to be_empty
          expect(row[5]).to be_a(String)
          expect(row[5]).not_to be_empty
        end
      end

      it 'throws an error if the file key is not recognised' do
        expect{ ConvertBankExtract.load_file(:fake_key) }.to raise_error("file_key 'fake_key' not recognised")
      end

    end

    it 'returns hashes for each row' do
      file = ConvertBankExtract.load_file(:csv)
      hashes = ConvertBankExtract.build_hashes(file, 1, '1-3', '600.00')
      hashes.each do |hash|
        expect(hash['id']).to be_a(Fixnum)
        expect(hash['period']).to match(/^\d+-\d+$/)
        expect(hash['statement']).to match(/^08046_\d{6}-\d{6}$/)
        expect(hash['date']).to be_a(DateTime)
        expect(hash['debit']).to hash[:credit] ? be_nil : be_a(Float)
        expect(hash['debit'].to_s).to hash[:credit] ? be_nil : match(/^\d+\.\d+$/)
        expect(hash['credit']).to hash[:debit] ? be_nil : be_a(Float)
        expect(hash['credit'].to_s).to hash[:debit] ? be_nil : match(/^\d+\.\d+$/)
        expect(hash['balance']).to be_a(Float)
        expect(hash['balance'].to_s).to match(/^\d+\.\d+$/)
        expect(hash['subcat']).to be_a(String)
        expect(hash['subcat']).not_to be_empty
        expect(hash['description']).to be_a(String)
        expect(hash['description']).not_to be_empty
      end
    end

    context 'returns the next period string' do
      tests = [
        { input: '1-1', expected: '1-2' },
        { input: '1-12', expected: '2-1' },
        { input: '9-12', expected: '10-1' },
        { input: '50-6', expected: '50-7' },
        { input: '999-12', expected: '1000-1' }
      ]
      tests.each do |test|
        it "when given #{test[:input]}" do
          new_period = ConvertBankExtract.next_period_string(test[:input])
          expect(new_period).to eq(test[:expected])
        end
      end
    end

    it 'archives the existing bank book' do
      archive_filename = "bank_archive_#{DateTime.now.strftime('%y%m%d%H%M%S')}.xlsx"
      archive_bank_book_filepath = "#{CONFIG['bookkeeping_archive_path']}#{archive_filename}"
      ConvertBankExtract.archive_current_bank_book(archive_filename)
      expect(File.exist?(CONFIG['bank_book_filepath'])).to be(false)
      expect(File.exist?(archive_bank_book_filepath)).to be(true)
    end

    it 'creates the new bank book file' do
      hashes = ConvertBankExtractSpecHelpers.test_hashes
      filepath = CONFIG['bank_book_filepath'].gsub('bank.xlsx', 'test_bank.xlsx')
      write_hash = { 'bank' => hashes }
      ConvertBankExtract.create_excel_file(filepath, write_hash)
      expect(File.exist?(filepath)).to be(true)
    end

  end

end