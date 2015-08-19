

require "database/pg"

class Settings

#   View "pg_catalog.pg_settings"
#    Column   |  Type   | Modifiers
# ------------+---------+-----------
#  name       | text    |
#  setting    | text    |
#  unit       | text    |
#  category   | text    |
#  short_desc | text    |
#  extra_desc | text    |
#  context    | text    |
#  vartype    | text    |
#  source     | text    |
#  min_val    | text    |
#  max_val    | text    |
#  enumvals   | text[]  |
#  boot_val   | text    |
#  reset_val  | text    |
#  sourcefile | text    |
#  sourceline | integer |

	FIELDS_FULL = {
		"name" => "Name",
		"setting" => "Setting",
		"unit" => "Unit",
		"category" => "Category",
		"short_desc" => "Description",
		"extra_desc" => "Information",
		"context" => "Context",
		"vartype" => "Type",
		"max_val" => "Max",
		"enumvals" => "Min",
		"boot_val" => "At Boot",
		"reset_val" => "Rest to",
		"sourcefile" => "Sourcefile",
		"sourceline" => "Sourceline"
	}

	ACC_TABLE = "pg_settings"
	ORDER_BY = "name"

	attr_reader :db
	attr_reader :debug	

	def initialize( config )
		@debug = config.has_key?( "debug" ) ? true : false
		@autoterminate = config.has_key?( "autoterm" ) ? true : false

		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Settings.new: #{config.to_s} \n") if @debug

		begin
			@db = PostgreSQL.new( config )
		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not create database connection: "+error.to_s+"\n"
		end

	end

	def supported_field?( field )
		return FIELDS_FULL.has_key?( field ) ? true : false
	end

	def search_rx( what = "name", pattern = nil )
		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Search Setting RegX : '#{what}' ~~ '#{pattern}' \n") if @debug
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  No active database connection!\n" if not @db
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Undefined search pattern : '#{pattern}'\n" if not pattern

		query = "SELECT #{FIELDS_FULL.keys().join(",")} FROM #{ACC_TABLE} WHERE #{what} ~~ '%#{pattern}%' ORDER BY #{ORDER_BY}"
		
				begin
					data = @db.query( query )
					return data
				rescue => error
					raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not query setting, no create database connection: "+error.to_s+"\n"
				end
			end
		
			def search_exact( what = "name", pattern = nil )
				STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Get Setting Match: '#{what}' = '#{pattern}' \n") if @debug
				raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  No active database connection!\n" if not @db
				raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Undefined search pattern : '#{pattern}'\n" if not pattern
		
				filter = "WHERE #{what} = '#{pattern}'"
		
				query = "SELECT #{FIELDS_FULL.keys().join(",")} FROM #{ACC_TABLE} #{filter} ORDER BY #{ORDER_BY}"
		
		begin
			data = @db.query( query )
			return data
		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not query setting, no create database connection: "+error.to_s+"\n"
		end
	end

	def search_all()
		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Get Setting All \n") if @debug
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  No active database connection!\n" if not @db

		query = "SELECT #{FIELDS_FULL.keys().join(",")} FROM #{ACC_TABLE} ORDER BY #{ORDER_BY}"

		begin
			data = @db.query( query )
			return data
		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not query setting, no create database connection: "+error.to_s+"\n"
		end
	end

end