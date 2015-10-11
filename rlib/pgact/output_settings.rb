require "pgact/output"
require "pgact/settings"

class SettingsOutput < Output

	ALL_FIELDS = Settings::FIELDS_FULL
	LONG_FILDS = Settings::FIELDS_FULL.keys()
	SHORT_FIELDS = ["name","setting","unit","boot_val","reset_val","short_desc"]

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
		print_head_hash( ALL_FIELDS, fields )
	end


	def print_line( fields, data_line )
		print_line_hash( fields, data_line )
	end


end