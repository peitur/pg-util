require "fileutils"
require 'json'

require "test/unit"

require "database/pg"

class TestDatabasePostgreSQL < Test::Unit::TestCase
##################################################################
#  \d pg_stat_activity
#            View "pg_catalog.pg_stat_activity"
#       Column      |           Type           | Modifiers
# ------------------+--------------------------+-----------
#  datid            | oid                      |
#  datname          | name                     |
#  pid              | integer                  |
#  usesysid         | oid                      |
#  usename          | name                     |
#  application_name | text                     |
#  client_addr      | inet                     |
#  client_hostname  | text                     |
#  client_port      | integer                  |
#  backend_start    | timestamp with time zone |
#  xact_start       | timestamp with time zone |
#  query_start      | timestamp with time zone |
#  state_change     | timestamp with time zone |
#  waiting          | boolean                  |
#  state            | text                     |
#  backend_xid      | xid                      |
#  backend_xmin     | xid                      |
#  query            | text                     |
######################################################################

	# {
	#   "host": "",
	# 	"dbname": "",
	#   "user": "",
	#   "password": ""
	# }
	def setup()

		filename = "db.json"
		debug = true

		login_data = load_json( filename, debug )
		login_data["debug"] = debug

 		@db = PostgreSQL.new( login_data )
	end

	def teardown()
		@db.close() if @db
	end


	def test_sql( )
		squery1 = "SELECT * FROM pg_stat_activity"
		squery2 = 'SELECT $1,$2,$3 FROM pg_stat_activity'
		squery2_params = [
			{:value => "usename", :type => 0, :format => 0},
			{:value => "state", :type => 0, :format => 0},
			{:value => "query", :type => 0, :format => 0}
		]

		squery2_params_val = []
		squery2_params.each{ |elem|
			squery2_params_val.push( elem[:value])
		}


		assert_not_nil( @db.query( squery1 ))
#		assert_not_nil( @db.query( squery2, squery2_params_val ))		
	end

	## loading login data from a json config file, to simplify test content	
	def load_json( filename, debug = false)
		raise RuntimeError, "Missing filename" if not filename

		if( File.exists?( filename ) or File.symlink?( filename ) )		
			return JSON.load( File.open( filename ) )
		else
			raise RuntimeError, "Could not find "+filename+"\n"
		end

	end	



end