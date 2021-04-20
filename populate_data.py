#!/usr/bin/env python

import argparse
from openkm3.store import KM3Store
from antares_data_server.backend_api import Configurer
import os
import pandas as pd

def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('-conf_file', type=str, default=None)
    args = parser.parse_args()
    conf_file = args.conf_file

    conf = Configurer.from_conf_file(conf_file)

    store = KM3Store()
    interpolation = store.get("ana20_01_bkg")
    with open(os.path.join(conf.root_wd, 
                           conf.antares_env_dir, 
                           conf.data_dir, 
                           'background.txt'), 'w') as fd:
        print(*interpolation.data, sep=' ', file=fd)
    
    lookup = store.get('ana20_01_acc')
    acc_df = pd.DataFrame.from_dict(lookup.data)
    with open(os.path.join(conf.root_wd, 
                           conf.antares_env_dir, 
                           conf.data_dir, 
                           'acc.txt'), 'w') as fd:
        acc_df.to_csv(fd, sep=' ', index=False, header=False)
    
    data = store.get('ana20_01_vo')
    data_df = data.get_dataframe()

    with open(os.path.join(conf.root_wd, 
                           conf.antares_env_dir, 
                           conf.data_dir, 
                           'ANTARES.data'), 'w') as fd:
        data_df.to_csv(fd, columns=['ra', 'decl', 'nhit', 'beta', 'mjd'], 
                       sep='\t', index=False, header=False)
     
if __name__ == '__main__':
    main()