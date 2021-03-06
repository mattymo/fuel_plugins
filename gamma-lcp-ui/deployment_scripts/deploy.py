#!/usr/bin/python


import os
import sys
import yaml


INPUT_YAML = '/etc/astute.yaml'
OUTPUT_YAML = '/etc/hiera/override/plugins.yaml'

try:
    with open(INPUT_YAML, 'r') as f:
        data = f.read()
except IOError:
    sys.exit('YAML file %s does not exist.' % INPUT_YAML)


dir = os.path.dirname(OUTPUT_YAML)

try:
    os.stat(dir)
except:
    os.mkdir(dir)  


data_dict = yaml.load(data)
if len(sys.argv) <2:
    sys.exit("Keys should be defined")

try:
    with open(OUTPUT_YAML, 'r') as f:
        out_str = f.read()
    out = yaml.load(out_str)
except Exception:
    out = None

out = out or {}
extra_vals = {}


def convert_to_array(vals):
    res = vals.copy()
    for key, value in vals.iteritems():
        if 'array' in key:
            res.pop(key)
            updated = [v.strip() for v in value.split(',')]
            res.update({key.replace('array_', ''): updated})
        elif 'hash' in key:
            res.pop(key)
            updated = {}
            for item in value.replace(' ', '').split(","):
                item = item.split(':')
                updated[item[0]] = item[1]
            res.update({key.replace('hash_', ''): updated})
        elif 'yaml' in key:
            res.pop(key)
            extra_vals[key.replace('yaml_', '')] = value
    return res


keys = sys.argv[1:]
for key in keys:
    updated_key = data_dict.get(key, None)
    if updated_key is None:
        sys.exit('%s is missing in YAML %s.' % (key,
                                                OUTPUT_YAML))
    if isinstance(updated_key, dict):
        key = key.replace('array_', '')
        updated_key = convert_to_array(updated_key)
    out.update({key: updated_key})
out.update(extra_vals)

with open(OUTPUT_YAML, 'w') as f:
    f.write(yaml.dump(out, default_flow_style=False))
print "Update YAML was stored in %s." % OUTPUT_YAML
