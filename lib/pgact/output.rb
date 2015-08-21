

require 'json'
require 'yaml'

class Output


	@output_type = 'stdout'
	@output_format = 'text'
	@debug = false
	@longest_line = 1

	def initialize( type = 'stdout', format = 'text', debug = false  )
		@output_format = format
		@output_type = type
		@debug = debug
		@longest_line = 0
	end




	################################################################################################
	private 
	################################################################################################

	def print_line_hash_yaml( fields, data_line )
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} Output format '#{@output_format}' not implemented!"
	end


	def print_line_hash_json( fields, data_line )
		raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} Output format '#{@output_format}' not implemented!"
	end


	def print_line_hash_text( fields, data_line )
		
		line_str = "| "
		fields.each { |atg|
			value = data_line[atg] ? data_line[atg].to_s : ""
			line_str += value+" | "
		}
		line_str +="\n"
		
		@longest_line = line_str.length()  if( @longest_line < line_str.length() ) 
			
		STDOUT.print( line_str )
	end

	

	################################################################################################
	public 
	################################################################################################
	
	def print_head_hash( all_fields, fields )
		return nil if( @output_format != 'text')

		STDOUT.print( "| " )
		fields.each { |atg|
			value = all_fields[atg] ? all_fields[atg].to_s : ""
			STDOUT.print( value+" | ")
		}

		STDOUT.print("\n")
		STDOUT.puts("|=============================================================================================|")		
	end


	
	def print_line_hash( fields, data_line )
	
		case @output_format
			when "text"
				print_line_hash_text( fields, data_line )
			when "json"
				print_line_hash_json( fields, data_line )
			when "yaml"
				print_line_hash_yaml( fields, data_line )
			else
				raise RuntimeError, "ERROR #{__FILE__}:#{__LINE__} Output format '#{@output_format}' not supported!"
		end
	end
end
