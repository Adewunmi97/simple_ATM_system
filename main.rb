require_relative 'account'
require_relative 'atm'

atm = Atm.new
acc1 = Account.new(00023456, 1234)
acc2 = Account.new(12345678, 5678)
atm.add_account(acc1)
atm.add_account(acc2)
acc1.welcome
atm.save_transaction
atm.load_history