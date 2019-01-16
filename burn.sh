#!/bin/bash

make DEFINES="-DBOARD2 -DADF4113" AVRDUDE_FLAGS="-c usbtiny" MCU="atmega328" clean main.burn
