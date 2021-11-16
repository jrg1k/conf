#!/usr/bin/env python

import json

path = "/usr/lib/code/product.json"
serviceurl = "https://marketplace.visualstudio.com/_apis/public/gallery"
cacheurl = "https://vscode.blob.core.windows.net/gallery/index"
itemurl = "https://marketplace.visualstudio.com/items"
config = None

with open(path, "r") as f:
    config = json.load(f)
    config["extensionsGallery"] = {
        "serviceUrl": serviceurl,
        "cacheUrl": cacheurl,
        "itemUrl": itemurl,
    }

if config is None:
    exit()

with open(path, "w") as f:
    json.dump(config, f, indent=4)
