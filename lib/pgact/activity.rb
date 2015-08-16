
require "database/pg"

class Activity
#  \d pg_stat_activity
#            View "pg_catalog.pg_stat_activity"
#       Column      |           Type           | Modifiers
# ------------------+--------------------------+-----------
#  datid            | oid                      |
#  datname          | name                     |
#  pid              | integer                  |
#  usesysid         | oid                      |
#  usename          | name                     |
#  application_name | text                     |
#  client_addr      | inet                     |
#  client_hostname  | text                     |
#  client_port      | integer                  |
#  backend_start    | timestamp with time zone |
#  xact_start       | timestamp with time zone |
#  query_start      | timestamp with time zone |
#  state_change     | timestamp with time zone |
#  waiting          | boolean                  |
#  state            | text                     |
#  backend_xid      | xid                      |
#  backend_xmin     | xid                      |
#  query            | text                     |

	ACC_TABLE = "pg_stat_activity"
	def initialize()
	end



end