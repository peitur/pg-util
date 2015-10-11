

import sys
sys.path.append( "../plib" )

import unittest
import pgwatch.util 

class PgWatchUtilTest( unittest.TestCase ):

	def setUp(self):

		self.config_missing = "no_such_config.json"
		self.config_ok = "ok_test.json"
		self.config_nok = "nok_test.json"


	def test_no_such_configfile(self):

		with self.assertRaises(Exception):
			pgwatch.util.load_json( self.config_missing )
      		

	def test_nok_config( self ):
		self.assertFalse( pgwatch.util.load_json( self.config_nok ) )


	def test_ok_config( self ):
		self.assertNotEqual( None, pgwatch.util.load_json( self.config_ok ) )



if __name__ == '__main__':
    unittest.main()