
require "database/pg"

class Activity
#  \d pg_stat_activity
#            View "pg_catalog.pg_stat_activity"
#       Column      |           Type           | Comment
# ------------------+--------------------------+-----------
#  datid            | oid                      | OID of the database this backend is connected to
#  datname          | name                     | Name of database
#  pid              | integer                  | PostgreSQL process id
#  usesysid         | oid                      | 
#  usename          | name                     | 
#  application_name | text                     | Connected application name
#  client_addr      | inet                     | 
#  client_hostname  | text                     |
#  client_port      | integer                  | 
#  backend_start    | timestamp with time zone | Client connection time
#  xact_start       | timestamp with time zone | Transaction start time
#  query_start      | timestamp with time zone | Start of query
#  state_change     | timestamp with time zone | Time of state change
#  waiting          | boolean                  | Waiting for Lock
#  state            | text                     | Current state
#  backend_xid      | xid                      | 
#  backend_xmin     | xid                      |	
#  query            | text                     | The actual query


	FIELDS = ["datname","pid","usename","application_name","client_hostname","query_start","state","waiting","query"]
	STATE_LIST = {
		"active" => "Executing query",
		"idle" => "Waiting for a new client command",
		"idle in transactoin" => "In a transaction, not executing",
		"idle in transaction (aborted)" => "In a transaction, not executing, error",
		"fastpath function call" => "Executing fast-path function",
		"disabled" => "Tracking disabled"
	}

	ACC_TABLE = "pg_stat_activity"
	ORDER_BY = "backend_start"

	attr_reader :db
	attr_reader :debug	

	def initialize( config )
		@debug = config.has_key?( "debug" ) ? true : false
		@autoterminate = config.has_key?( "autoterm" ) ? true : false

		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Activity.new: #{config.to_s} \n") if @debug

		
		begin
			@db = PostgreSQL.new( config )
		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not create database connection: "+error.to_s+"\n"
		end
	end

	def close()
		@db.close() if @db
	end




	def get_activity( state = "active" )
		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Get Activity : #{state} \n") if @debug
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  No active database connection!\n" if not @db
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Unknown state : #{state}\n" if state != nil and not STATE_LIST.has_key?( state )


		where = ""
		if( state )
			where = "WHERE state = '#{state}'"
		end

		fields = FIELDS.join(",")
		query = "SELECT #{fields} FROM #{ACC_TABLE} #{where} ORDER BY #{ORDER_BY}"

		begin

			data = @db.query( query )

			return data

		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not create database connection: "+error.to_s+"\n"
		end

	end

	def get_info()
		return {
			'orderby' => ORDER_BY,
			'fields' => FIELDS,
			'table' => ACC_TABLE,
			'states' => STATE_LIST
		}
	end

	

	
end