

import database.postgres
import pgwatch.util

class PgWatchPgConfig:

	def __init__( self, **args ):

		self.debug = False

		if 'filename' in args:
			cfg = pgwatch.util.load_json( filename )
		else if 'config' in args:
			cfg = args['config']
		else:
			raise RuntimeError( "Missing configuration data")

		self.db = database.postgres.postgres( cfg )

