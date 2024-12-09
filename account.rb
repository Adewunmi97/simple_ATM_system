require 'time'

class Account
  attr_reader :acc_no, :balance, :trans_history
  def initialize(acc_no, pin)
    @acc_no = acc_no
    @pin = pin
    @balance = 0.00
    @trans_history = []
    @authenticated = false
  end

  def welcome
    puts "Welcome to the banking app, please enter: 'b' for balance or 'd' for deposit or 'h' for transaction history or 'w' for withdrawal or 'e' for exit:"
    response = gets.chomp.downcase
  case response
  when "b"
    bal
  when "d"
    deposit
  when "h"
    transaction_history
  when "w"
    withdrawal
  when "e"
    Kernel.exit
  else 
    error
  end
  end

  def authenticate
    puts "Please enter your 4 digit PIN:"
    pin = gets.chomp 
      if pin.length != 4
      puts "PIN can not be less or greater than 4"
      @authenticated = false
      return
      elsif pin.match?(/\D/)
      puts "PIN can only contain numbers"
      @authenticated = false
      return
    end

    if @pin == pin.to_i 
      puts "Authentication successful! PIN is valid."
      @authenticated = true
    else
      puts "Authentication failed! Incorrect pin"
      @authenticated = false
      puts "Please try again with your correct PIN."
      authenticate
    end
  end

  def check_authentication
    unless @authenticated
      puts "You must have an account with a valid PIN first!"
      authenticate
      return false unless @authenticated
    end
    true
  end

  def deposit
    return unless check_authentication
    puts "How much would you like to deposit?"
    amount = gets.chomp.to_f
    if amount <= 0
      puts error
    else
    @balance += amount
    record_transaction('deposit', amount)
    puts "Deposit successful! Your new balance is ##{@balance}"
    end
    further_transaction
  end

  def withdrawal
    return unless check_authentication
    puts "How much would you like to withdraw?"
    amount = gets.chomp.to_f
    if amount > 0 && amount <= @balance
    @balance -= amount
    record_transaction('withdrawal', amount)
    puts "Withdrawal successful! Your new balance is ##{@balance}"
    else
      puts "Insufficient balance"
    end
    further_transaction
  end

  def bal
    return unless check_authentication
    puts "Your current balance is ##{@balance}"
    further_transaction
  end

  def record_transaction(type, amount)
    @trans_history << {
      type: type,
      amount: amount,
      date: Time.now,
      balance: @balance
    }
  end

  def transaction_history
    return unless check_authentication
    if @trans_history.empty?
      puts "No transaction history!"
    else
    puts "Mini Statement (Last 5 Transactions):"
    @trans_history.last(5).each do |transaction|
      puts "#{transaction[:date]} - #{transaction[:type]} : #{transaction[:amount]} : #{transaction[:balance]}}"
    end
    end
    further_transaction
  end

  def further_transaction
    loop do
    puts "Would you like to do a further transaction?"
      puts "y for Yes and n for No: "
      response = gets.chomp.downcase
      case response
      when "y" 
        welcome
        break
      when "n"
        puts "Thank you for banking with us!"
        Kernel.exit
      else
        puts "Invalid input. Please try again."
      end
    end
  end

  def error
    puts "Error: Invalid transaction! Please try again!"
    further_transaction
  end
end
