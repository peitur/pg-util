require "pgact/output"
require "pgact/settings"

class SettingsOutput < Output

	ALL_FIELDS = Settings::FIELDS_FULL
	LONG_FILDS = []
	SHORT_FIELDS = []

	def initialize( type = 'stdout', format = 'text', debug = false  )
		super( type, format, debug )
	end



	def print( fields, data_line )

	end


end