#!/bin/bash

make DEFINES="-DBOARD2 -DADF4113" AVRDUDE_FLAGS="-c usbtiny" clean main.burn
