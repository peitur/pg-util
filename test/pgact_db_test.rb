require "fileutils"
require 'json'

require "test/unit"

require "database/pg"

class TestDatabasePostgreSQL < Test::Unit::TestCase

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

		@db = PostgreSQL.new( login_data )
	end

	def teardown()
		@db.close() if @db
	end


	def test_sql( )
		squery = "SELECT * FROM pg_stat_activity"

		
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