
import database.postgres
import pgwatch.util
import sys
import traceback

class PgWatchAction:

	def __init__( self, **args ):
		self.debug = False
		if 'debug' in args:	self.debug = True

		if self.debug: print("DEBUG: PgWatchAction: "+args.keys().__str__()+"\n" )


		self.db = None
		try:
			if 'filename' in args:
				filename = args['filename']

				if self.debug: print("DEBUG: Config file: "+filename+"\n" )

				cfg = pgwatch.util.load_json( filename, debug=self.debug )

				if self.debug: print("DEBUG: Loaded Config : "+cfg.keys().__str__()+"\n" )

			elif 'config' in args:
				cfg = args['config']
			else:
				raise RuntimeError( "Missing configuration data")


			if self.debug: print("DEBUG: Action Config: "+cfg.keys().__str__()+"\n" )

			self.db = database.postgres.PgWatchPostgresDb( **cfg )
		
		except Exception as error:
#			print( ">>>>>>>>>>>>>>>>> "+sys.exc_info().__str__() )
			raise RuntimeError( "Activity connection object fail: "+error.__str__()+"\n")


	def close( self ):
		if self.db: self.db.close()
		return True


	def getActivity( self ):
		if not self.db: raise RuntimeError("ERROR: Not connected to database" )

		reply = []

		sql = "SELECT * FROM pg_stat_activity ORDER BY query_start"
#		sql = "SELECT * FROM information_schema.tables"

		try:
			for row in self.db.prepare( sql ):
				reply.append( row )
#				print(">> "+row.__str__() )


		except Exception as error:
			raise error


		return reply
