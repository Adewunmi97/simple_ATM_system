require_relative 'account'
require 'json'

class Atm
  def initialize
    @accounts= []
  end

  def add_account(account)
    @accounts << account
  end

  def find_account(acc_no)
    @accounts.find do |account|
      account.acc_no == acc_no
    end
  end

  def save_transaction(file = 'all_transactions.json')
    transaction = @accounts.map do |detail|
      {
        acc_no: detail.acc_no,
        acc_history: detail.trans_history
      }
    end.to_json
    File.open(file, 'w') do |f|
      f.write(transaction)
    end
    puts "All transactions are saved in #{file}"
  end

  def load_history(file='all_transactions.json')
    existing_transactions = File.exist?(file)
    if existing_transactions
      json_data = File.read(file)
      @accounts = JSON.parse(json_data).map do |hash|
        Account.new(hash['acc_no'], hash['trans_history'])
      end
      puts "All transactions are loaded from #{file}"
    else
      puts "File #{file} does not exist."
    end
  end
end
