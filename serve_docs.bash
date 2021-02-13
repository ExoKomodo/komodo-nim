#! /bin/bash

nimble docKomodo
python3 -m http.server 7029 --directory htmldocs
