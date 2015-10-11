

import sys
sys.path.append( "../plib" )

import unittest
import pgwatch.util
import pgwatch.action

class PgWatchActionTest( unittest.TestCase ):

	def setUp(self):

		self.debug = False
		self.secretfile = "ok_test.secret.json"
		self.action = None

		try:
			self.action = pgwatch.action.PgWatchAction( filename=self.secretfile, debug=self.debug )
		except Exception as exp:
			print( "Could not create activiry object: ", exp )


	def tearDown(self):
		if self.action: self.action.close()

	def test_test_object( self ):
		self.assertTrue( self.action )

	def test_get_activity( self ):
		self.assertNotEqual( None, self.action.getActivity() )



if __name__ == '__main__':
    unittest.main()