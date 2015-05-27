================
Example of usage
================

Input YAML will be taken from INPUT_YAML defined in yaml_parser.py module.
Default input YAML /etc/astute.yaml

Result will be stored in OUTPUT_YAML defined in yaml_parser.py module.
Default output YAML /etc/hiera/override/plugins.yaml

Directory with YAML files will be generated in missing case.

Run follow command for update of output YAML:


.. code-block:: bash

  ./deploy.py gamma-lcp-ui gamma-lcp-nova ... 
