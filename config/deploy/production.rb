server "dualstack.gcmc-515670996.ap-northeast-1.elb.amazonaws.com.", user: "akio", roles: %w{app db web}

set :ssh_options, keys: "~/.ssh/gcmc_key_rsa"