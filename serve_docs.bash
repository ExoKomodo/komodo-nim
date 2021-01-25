#! /bin/bash

./generate_docs.bash
python3 -m http.server 7029 --directory htmldocs
