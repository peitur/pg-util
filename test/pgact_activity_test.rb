require "fileutils"
require 'json'

require "test/unit"

require "pgact/activity"

class TestDatabaseActivity < Test::Unit::TestCase
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
		login_data["autoterm"] = false

 		@db = Activity.new( login_data )
	end

	def teardown()
		@db.close() if @db
	end


	def test_activity( )

		assert_not_nil( aa = @db.get_activity() )
		assert_not_nil( ab = @db.get_activity( "idle" ) )
		assert_not_nil( ac = @db.get_activity( nil ) )

		STDOUT.puts("==============================================\n")
		STDOUT.puts("AA: "+aa.to_s+"\n")
		STDOUT.puts("==============================================\n")
		STDOUT.puts("AB: "+ab.to_s+"\n")
		STDOUT.puts("==============================================\n")
		STDOUT.puts("AC: "+ac.to_s+"\n")
		STDOUT.puts("==============================================\n")

		assert_raise do 
			ad = @db.get_activity( "badstate" )
		end



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