require "pg"

class PostgreSQL

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


	attr_accessor :host,:user,:password,:database
	attr_reader :debug, :autoterminate
	def initialize( config = {} )
		@debug = config.has_key?( "debug" ) ? true : false



		@user = config.has_key?( "user" ) ? config{"user"} : nil
		@password = config.has_key?( "password" ) ? config{"password"} : nil
		@host = config.has_key?( "host" ) ? config{"host"} : "localhost"
		@database = config.has_key?( "dbname" ) ? config{"dbname"} : "template1"
		@autoterminate = config.has_key?( "autoterm" ) ? true : false

		begin
			@handle = PG.connect( :dbname => @database, :host => @host, :user => @user, :password => @password )
		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not connect to database : "+error.to_s+"\n"
		end
	end

	def query( sql, params = nil)
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} No SQL in query function"+"\n" if not sql
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} No database conection"+"\n" if not self.is_open?()

		reply = []

		begin

			if( params )
				res = @handle.exec_params( sql , params )
			else
				res = @handle.exec( sql )
			end

			res.each{ |row|
				reply.push( row )
			}

		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} SQL : "+error.to_s+"\n"
		ensure
			@handle.finish() if @autoterminate and @handle
		end

		return reply
	end

	def close()
		@handle.finish() if @handle
	end

	def is_open?()
		if( @handle )

			if( @handle.finished?() )
				return true 
			else
				return false
			end

		else
			return false
		end
	end

end