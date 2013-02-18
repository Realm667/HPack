#!/bin/bash

# Build script for Linux by Dusk

# It takes one optional argument, an alternate destination path, meaning that
# calling for instance "./build.sh ~/doom" will build omega_data_*.pk3 directly
# into ~/doom instead

# =============================================================================

# Determine where to build
if [ -z $1 ]; then
	dest=$(pwd)
else
	if [ ! -d $1 ]; then
		echo "WARNING: You supplied $1 as destination path for me, but it doesn't exist or isn't a directory."
		dest=$(pwd)
	elif [ ! -w $1 ]; then
		echo "WARNING: You supplied $1 as destination path for me, but it's not writable."
		dest=$(pwd)
	else
		dest="$1"
	fi
fi

# Check that our environment is good
echo "Checking environment... "

# Check permissions
if [ ! -w ".." ]; then
	echo "ERROR: I can't write into the parent directory! Please check the permissions and try again."
	exit 5
fi

# Check svnversion
if [ -z $(which svn) -o -z $(which svnversion) ]; then
	echo "ERROR: You don't seem to have SVN installed! The svn and svnversion commands are needed to build."
	exit 1
fi

# Check zip
if [ -z $(which zip) ]; then
	echo "ERROR: You don't seem to have zip installed! The zip command is needed to build."
	exit 1
fi

# Get filename. M is added automatically
rev=$(svnversion)
fn="hpack_r$rev.pk3"

# Must not be exported.
if [ "$rev" == "exported" ]; then
	echo "ERROR: This is no SVN directory!"
	exit 2
fi

# ./pk3/ must exist. This shouldn't happen..
if [ ! -d "./pk3" ]; then
	echo "ERROR: ./pk3/ either does not exist or is not a directory."
	exit 3
fi

# build/ already exists!
if [ -d "build/" ]; then
	echo "build/ must not exist in order to build. Delete it? (y/n)"
	rm -rI ../build/ # Delete it but ask the user first
	
	if [ -d "build/" ]; then
		# If it still exists, the user chose not delete it
		exit 4
	fi
fi

echo "Environment OK. Going to build revision $rev."

# Export it
echo -n "Exporting... "

svn export ./pk3 ./build >/dev/null
if [ $? -ne 0 ]; then
	echo "Export failed."
	exit 1
fi

echo "done"

cd build

echo -n "Creating archive $fn... "
zip -r -1 $fn * >/dev/null

if [ $? -ne 0 ]; then
	echo "ERROR: Archive did not build properly."
	exit 1
fi

echo "done"

echo -n "Moving $fn... "
mv $fn $dest
if [ $? -ne 0 ]; then
	echo "Something went wrong with file moving. Retrieve the archive from build/ directory and remove build/ afterwards."
	exit 1
fi

echo "done"

echo -n "Clearing build directory... "
cd .. && rm -rf build
echo "done"

echo "Finished!"
