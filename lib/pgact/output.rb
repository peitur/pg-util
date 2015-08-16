

require 'json'
require 'yaml'

class PgAct::Output


	@@output_type = 'stdout'
	@@output_format = 'text'
	@@debug = false

	def initialize( type = 'stdout', format = 'text', debug = false  )
		@@output_format = format
		@@output_type = type
		@@debug = debug
	end



end