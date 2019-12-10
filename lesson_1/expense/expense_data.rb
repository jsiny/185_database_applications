class ExpenseData
  def initialize
    @connection = PG.connect(dbname: 'expenses')
    setup_schema
  end
  
  def add_expense(amount, memo)
    date = Date.today
    sql = 'INSERT INTO expenses (amount, memo, created_on) VALUES ($1, $2, $3)'
    @connection.exec_params(sql, [amount, memo, date])
  end

  def list_expenses
    result = @connection.exec('SELECT * FROM expenses ORDER BY created_on;')
    display_expenses(result)
  end

  def search_expenses(param)
    sql = 'SELECT * FROM expenses WHERE memo ILIKE $1 ORDER BY created_on;'
    result = @connection.exec_params(sql, ["%#{param}%"])
    display_expenses(result)
  end

  def delete_expense(id)
    sql = 'SELECT * FROM expenses WHERE id = $1;'
    result = @connection.exec_params(sql, [id])

    if result.ntuples == 1
      sql = 'DELETE FROM expenses WHERE id = $1'
      @connection.exec_params(sql, [id])
      
      puts 'The following expense has been deleted:'
      display_expenses(result)
    else
      puts "There is no expense with the id '#{id}'."
    end
  end

  def delete_all_expenses
    @connection.exec('DELETE FROM expenses;') 
    puts 'All expenses have been deleted.'
  end

  private

  def display_expenses(expenses)
    display_count(expenses)
    expenses.each do |tuple|
      columns = [ tuple['id'].rjust(3),
                  tuple['created_on'].rjust(10),
                  tuple['amount'].rjust(12),
                  tuple['memo'] ]
      
      puts columns.join(' | ')
    end 
    display_total(expenses)
  end

  def display_count(expenses)
    count = expenses.ntuples.zero? ? 'no' : "#{expenses.ntuples}"
    puts "There are #{count} expenses."
  end

  def display_total(expenses)
    puts '-' * 50
    total = expenses.field_values('amount').map(&:to_f).sum
    puts "Total #{total.to_s.rjust(25)}"
  end

  def setup_schema
    result = @connection.exec <<~SQL
      SELECT COUNT(*)
        FROM information_schema.tables
       WHERE table_schema = 'public'
         AND table_name = 'expenses';
    SQL

    create_table if result[0]['count'] == '0'
  end

  def create_table
    @connection.exec <<~SQL
      CREATE TABLE expenses (
        id serial PRIMARY KEY,
        amount numeric(6,2) NOT NULL CHECK (amount >= 0.01),
        memo text NOT NULL,
        created_on date NOT NULL
      );
    SQL
  end
end