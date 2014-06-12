#!/bin/sh -x

#  mogen_script.sh
#  BioCaching
#
#  Created by Andy Jeffrey on 10/06/2014.
#  Copyright (c) 2014 MPApps.net. All rights reserved.
#
#  Script File To (Re)Generate Core Data Entity Classes
#  Requires local installation of Mogenerator tool http://rentzsch.github.com/mogenerator/

MODEL_NAME="BioCaching"
MODEL_DIR="Model/ManagedObjects"
/usr/local/bin/mogenerator --template-var arc=true \
-m ${MODEL_NAME}.xcdatamodeld/*.xcdatamodel \
-H ${MODEL_DIR}/ \
-M ${MODEL_DIR}/Generated/ \
--includeh=${MODEL_DIR}/ManagedObjects.h

