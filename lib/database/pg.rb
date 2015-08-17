require "pg"

class PostgreSQL



	attr_accessor :host,:user,:password,:database
	attr_reader :debug, :autoterminate
	def initialize( config )
		@debug = config.has_key?( "debug" ) ? true : false
		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} PostgreSQL.new: #{config.to_s} \n") if @debug

		@user = config.has_key?( "user" ) ? config["user"] : nil
		@password = config.has_key?( "password" ) ? config["password"] : nil
		@host = config.has_key?( "host" ) ? config["host"] : "localhost"
		@database = config.has_key?( "dbname" ) ? config["dbname"] : "template1"
		@autoterminate = config.has_key?( "autoterm" ) ? true : false

		begin
			@handle = PG::Connection.open( :dbname => @database, :host => @host, :user => @user, :password => @password )
		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not connect to database : "+error.to_s+"\n"
		end
	end


	def query( sql, params = nil)
		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Query: #{sql}, #{params.to_s} \n") if @debug

		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} No SQL in query function"+"\n" if not sql
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} No database conection"+"\n" if not self.is_open?()

#		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Handle: #{@handle.to_s} \n") if @debug


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
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} SQL [#{sql}] : #{error.to_s}"+"\n"
		end

		return reply
	end

	def close()
		@handle.finish() if @handle and not @handle.finished?()
	end

	def is_open?()
		if( @handle )

			if( @handle.finished?() )
				return false 
			else
				return true
			end

		else
			return false
		end
	end

end