#!/bin/bash

# Simply run our propagate environment variables script first
propagate_environment.pl

# Then start apache in the foreground
apache2-foreground

