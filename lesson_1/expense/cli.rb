require 'io/console'

class CLI
  POSITIVE_ANSWERS = %w(y Y)

  def initialize
    @application = ExpenseData.new
    @arguments = []
  end

  def run(arguments)
    @arguments = arguments

    case @arguments.first
    when 'list'   then @application.list_expenses
    when 'add'    then attempt_to_add_expense
    when 'search' then @application.search_expenses(@arguments[1])
    when 'delete' then @application.delete_expense(@arguments[1])
    when 'clear'  then check_clear
    else display_help
    end
  end

  private

  def check_clear
    puts 'This will remove all expenses. Are you sure? (y/n)'
    answer = $stdin.getch
    @application.delete_all_expenses if POSITIVE_ANSWERS.include?(answer)
  end

  def attempt_to_add_expense
    amount = @arguments[1]
    memo   = @arguments[2]
    abort 'You must provide an amount and memo' unless amount && memo
    @application.add_expense(amount, memo)
  end 

  def display_help
    puts <<~MSG
      An expense recording system
  
      Commands:
      
      add AMOUNT MEMO [DATE] - record a new expense
      clear - delete all expenses
      list - list all expenses
      delete NUMBER - remove expense with id NUMBER
      search QUERY - list expenses with a matching memo field
    MSG
  end
end