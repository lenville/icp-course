# Open Terminal 1
dfx new mysite
cd mysite
dfx start

# Open Terminal 2
cd mysite
dfx deploy

# Get SDR Faucet then do:
dfx identity get-principal # get identity information
dfx wallet --network=ic # interact with wallet
dfx wallet --network=ic balance # check balance
dfx deploy --network=ic # deploy mysite to the public domain

# Get DFX cache files
dfx cache

# Get DFX version compiler path
dfx cache show

# Set compiler path into PATH
export PATH=$(dfx cache show):$PATH

# To see where is the compiler
which moc

# Run compiler with both base library and source code
moc --package base $(dfx cache show)/base -r <sourcecode file path>