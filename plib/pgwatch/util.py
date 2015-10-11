
import json
import os.path 

def load_json( filename, **options ):

	debug = False
	if 'debug' in options:	debug = True

	if debug: 
		print("UTIL: DEBUG: Config file: "+filename+"\n" )


	data = ""
	fd = None

	if not os.path.exists( filename ) : raise RuntimeError( "File "+filename+" could not be found" )

	try:
		fd = open( filename, "r" )

		for line in fd:
			line.rstrip("\n\r")
			data += " "+line

	except Exception as error:	raise error 
	finally: fd.close()

#	if debug: print("DEBUG: Data read from file "+filename+"\n"+data+"\n" )

	try:
		if debug: print("DEBUG: Data read from file "+filename+"\n"+data+"\n" )
		return json.loads( data )
	except ValueError as error:
		if debug: print("ERROR: Bad file content in "+filename+"\n")
		raise error
	except Exception as error: 
		if debug: print("ERROR: Could not load json from "+filename+"\n")
		raise error

	return None