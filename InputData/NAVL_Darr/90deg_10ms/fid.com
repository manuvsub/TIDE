#!/bin/csh

bruk2pipe -in ./ser \
  -bad 0.0 -aswap -DMX -decim 200 -dspfvs 20 -grpdly 68.003173828125  \
  -xN              4096  -yN              1024  \
  -xT              1994  -yT               512  \
  -xMODE            DQD  -yMODE        Complex  \
  -xSW       100000.000  -ySW        16666.667  \
  -xOBS         176.116  -yOBS         176.116  \
  -xCAR          99.990  -yCAR          99.990  \
  -xLAB            13Cx  -yLAB            13Cy  \
  -ndim               2  -aq2D          States  \
  -out ./test.fid -verb -ov

sleep 5
