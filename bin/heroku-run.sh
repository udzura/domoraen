#!/bin/bash

export RUBYOPT='-EUTF-8'
export RACK_ENV=production

ruby ./bin/domoraen-httpd
