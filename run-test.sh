#!/bin/bash

for t in $(ls level*); do
	./$t
done
