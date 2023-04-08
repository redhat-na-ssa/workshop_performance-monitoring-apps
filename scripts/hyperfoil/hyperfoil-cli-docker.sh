#!/bin/sh
 docker run -it --rm\
  -v ./scripts/hyperfoil:/benchmarks:Z\
  -v ./scripts/hyperfoil/reports:/tmp/reports:Z\
  --network=lab-apps_default\
  quay.io/hyperfoil/hyperfoil cli