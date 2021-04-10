server "3.114.103.248", user: "akio", roles: %w{app db web}

set :ssh_options, port: 22, keys: '~/.ssh/gcmc_key_rsa'