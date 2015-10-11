import postgresql

class PgWatchPostgresDb:
	"""
		Simple postgresql database handle wrapper for pgwatch
	"""

	def __init__( self, **args ):

		self.debug = False
		if 'debug' in args:	self.debug = True

		if self.debug: print("DEBUG: PgWatchPostgresDb: "+args.keys().__str__()+"\n" )

		if 'host' in args:
			self.host = args['host']
		else:
			self.host = "localhost"

		if 'port' in args:
			self.port = args['port']
		else:
			self.port = "5432"

		if 'dbname' in args:
			self.dbname = args['dbname'] 
		else:
			self.dbname = "template1"

		if 'user' in args:
			self.user = args['user']
		else:
			raise RuntimeError("No user for database")

		if 'password' in args:	
			self.password = args['password']
		else:
			raise RuntimeError("No password for database")


		try:
			constring = "pq://"+self.user+":"+self.password+"@"+self.host+":"+self.port+"/"+self.dbname
#			if self.debug: print("DEBUG: Connection string: "+constring+"\n" )
			self.handle = postgresql.open( constring )
		except Exception as error:
			if self.debug: print("DEBUG: Could not open database: "+error+"\n" )
			raise error


	def close( self ):
		self.handle.close()

	def dbname( self, value=None ):
		if value: self.dbname = value		
		return self.dbname

	def user( self, value=None ):
		if value: self.user = value
		return self.user

	def password( self, value=None ):
		if value: self.password = value
		return self.password

	def host( self, value=None ):
		if value: self.host = value
		return self.host

	def handle( self, value=None ):
		if value: self.handle = value
		return self.handle

	def prepare( self, sql ):
		reply = []
		try:
			for row in self.handle.prepare( sql ):
				reply.append( row )
		except: raise
		return reply

	def execute( self, sql ):
		reply = []
		try:
			for row in self.handle.execute( sql ):
				reply.append( row )
		except: raise
		return reply



	def __str__( self ):
		return "pq://"+self.user+":"+self.password+"@"+self.host+":"+self.port+"/"+self.dbname


# if __name__ == '__main__':
#    postgres.main()