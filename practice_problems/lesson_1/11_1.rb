require 'pg'

connection = PG::Connection.new(dbname: 'expenses')

connection.exec_params('SELECT 1 + $1 + $2', [2]).values

# ERROR:  bind message supplies 1 parameters, but prepared statement "" requi
# res 2 (PG::ProtocolViolation)