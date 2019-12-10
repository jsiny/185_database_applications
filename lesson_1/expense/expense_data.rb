class ExpenseData
  def initialize
    @connection = PG.connect(dbname: 'expenses')
  end
  
  def add_expense(amount, memo)
    date = Date.today
    sql = 'INSERT INTO expenses (amount, memo, created_on) VALUES ($1, $2, $3)'
    @connection.exec_params(sql, [amount, memo, date])
  end

  def list_expenses
    result = @connection.exec('SELECT * FROM expenses ORDER BY created_on;')
  
    result.each do |tuple|
      columns = [ tuple['id'].rjust(3),
                  tuple['created_on'].rjust(10),
                  tuple['amount'].rjust(12),
                  tuple['memo'] ]
      
      puts columns.join(' | ')
    end
  end

  def search_expenses(param)
    sql = 'SELECT * FROM expenses WHERE memo ILIKE $1 ORDER BY created_on;'
    result = @connection.exec_params(sql, ["%#{param}%"])

    p result.values
  end
end