
require "pgact/output"

class ActivityOutput < Output

	ALL_FIELDS = Activity::FIELDS
	LONG_FILDS = Activity::FIELDS.keys()
	SHORT_FIELDS = []

	def initialize( type = 'stdout', format = 'text', debug = false  )
		super( type, format, debug )
	end

	def short_fields()
		return SHORT_FIELDS
	end

	def long_fields()
		return LONG_FILDS
	end


	def print_line( fields, data_line )
		
		self.print_line_text( fields, data_line) if( @output_format == 'text' )

	end

	def print_head( fields )

		return nil if( @output_format != 'text')

		STDOUT.print( "| " )
		fields.each { |atg|
			value = ALL_FIELDS[atg] ? ALL_FIELDS[atg].to_s : ""
			STDOUT.print( value+" | ")
		}

		STDOUT.print("\n")		
	end

	def print_line_text( fields, data_line )
		
		STDOUT.print( "| " )
		fields.each { |atg|
			value = data_line[atg] ? data_line[atg].to_s : ""
			STDOUT.print( value +" | " )
		}

		STDOUT.print("\n")

	end


end