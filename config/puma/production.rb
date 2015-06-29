#!/usr/bin/env puma
app_path = "/home/deploy"



# The directory to operate out of.
#
# The default is the current directory.
#
directory "#{app_path}/current"

environment 'production'

daemonize

pidfile "#{app_path}/current/tmp/pids/puma.pid"

state_path "#{app_path}/current/tmp/pids/puma.state"

# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# ("append") specifies whether the output is appended, the default is
# "false".
#
# stdout_redirect '/u/apps/lolcat/log/stdout', '/u/apps/lolcat/log/stderr'
# stdout_redirect '/u/apps/lolcat/log/stdout', '/u/apps/lolcat/log/stderr', true

# Disable request logging.
#
# The default is "false".
#
quiet

# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
#
# The default is "0, 16".
#
threads 4, 32

# Bind the server to "url". "tcp://", "unix://" and "ssl://" are the only
# accepted protocols.
#
# The default is "tcp://0.0.0.0:9292".
#
# bind 'tcp://0.0.0.0:9292'
bind "unix://#{app_path}/current/tmp/sockets/puma.sock"

prune_bundler

