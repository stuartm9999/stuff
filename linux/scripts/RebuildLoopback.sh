cd /usr/src/v4l2loopback

# Clean previous build
sudo make clean

# Build the module
sudo make

# Locate your built module
MODULE=v4l2loopback.ko
MODULE_PATH=$(pwd)/$MODULE

# Sign the module using your MOK key/cert
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 \
    $PWD/MOK.key \
    $PWD/MOK.crt \
    $MODULE_PATH

# Copy the signed module to the updates folder
sudo cp $MODULE_PATH /lib/modules/$(uname -r)/updates/

# Update module dependencies
sudo depmod -a

# Verify signature
modinfo /lib/modules/$(uname -r)/updates/v4l2loopback.ko | grep signer

