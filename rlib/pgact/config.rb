
require 'util'

class PgactConfig
   
 
   
    @@defaults = {
      'dbname'   => { 'value' => "template1", 'desc' => "Database default to use" },
    }
   
    attr_accessor :debug
    attr_reader :filename, :config
    
    def initialize( filename, debug = false )
        @filename = filename
        @debug = debug
        
        STDERR.puts( "DEBUG #{__FILE__}/#{__LINE__}: Loading configuration from #{@filename}") if( @debug )
        
        begin
            @config = Util.load_json( @filename, @debug )

            if( not @config )
                raise ArgumentError, "ERROR #{__FILE__}/#{__LINE__}: Could not load configuration object from file #{filename}: "+"\n"
            end
        rescue => error
            raise ArgumentError, "ERROR #{__FILE__}/#{__LINE__}: Could not load configuration #{filename}: "+error.to_s+"\n"
        end
    end
    
    def key?( key )
        return @config.key?( key )
    end
   
    def key( key )
        return @config[key]
    end
   
    def key!(key, val)
        @config[key] = val
        return @config[key]
    end
    
    def default( key )
        
        if( @@defaults.key?( key ) )
            data = @@defaults[ key ]
            return data[ 'value' ]
        end
        
        return nil
    end
    
    def options( )
        return @@defaults.keys()
    end
    
    def to_s
        return "\"filenmae\"=>\"#{@filename}\", \"debug\"=>\"#{@debug}\", \"config\"=>\"#{@config}\""
    end
    
end