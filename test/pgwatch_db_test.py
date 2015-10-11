

import sys
sys.path.append( "../plib" )

import unittest
import database.postgres

class PgWatchPostgresTest( unittest.TestCase ):

	def setUp(self):

		self.db = None

		try:
			self.db = database.postgres.postgres( user="peter", password="zsolt!", dbname="reptest" )
		except Exception as exp:
			print( "Could not create postgres connection: ", exp )


	def tearDown(self):
		if self.db: self.db.close()

	def test_something( self ):
		if not self.db:	raise RuntimeError("Testcase has no db connection") 
	
		print("... test ...")


if __name__ == '__main__':
    unittest.main()