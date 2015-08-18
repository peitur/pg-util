

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

	FIELDS_FULL = [
		"name",
		"setting",
		"unit",
		"category",
		"short_desc",
		"extra_desc",
		"context",
		"vartype",
		"sourceline",
		"min_val",
		"max_val",
		"enumvals",
		"boot_val",
		"reset_val",
		"sourcefile",
		"sourceline"
	]

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
		return FIELDS_FULL.index( field ) ? true : false
	end

	def search_rx( what = "name", pattern = nil )
		STDERR.puts("DEBUG #{__FILE__}:#{__LINE__} Search Setting RegX : '#{what}' ~~ '#{pattern}' \n") if @debug
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  No active database connection!\n" if not @db
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Undefined search pattern : '#{pattern}'\n" if not pattern

		query = "SELECT #{FIELDS_FULL.join(",")} FROM #{ACC_TABLE} WHERE #{what} ~~ '%#{pattern}%' ORDER BY #{ORDER_BY}"

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

		query = "SELECT #{FIELDS_FULL.join(",")} FROM #{ACC_TABLE} WHERE #{what} = '#{pattern}' ORDER BY #{ORDER_BY}"

		begin
			data = @db.query( query )
			return data
		rescue => error
			raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__}  Could not query setting, no create database connection: "+error.to_s+"\n"
		end
	end

end