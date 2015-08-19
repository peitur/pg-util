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

	def printx( fields, data_line )
		
		STDOUT.print( fields.length().to_s+"> ")

		fields.each { |atg|
			value = data_line[atg] ? data_line[atg].to_s : ""
			STDOUT.print( "\t "+value )
		}

		STDOUT.print("\n")

	end


end