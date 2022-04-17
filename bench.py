import time
import dask.dataframe as dd
from dask.distributed import Client
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import gc

if __name__ == "__main__":
    # connect to the client
    client = Client("tcp://10.10.1.1:8786")
    print("Connected to Dask Cluster: ", client)
    
    # create the dataset
    data = {
        'parquet': {
            '1': list(),
            '10': list(),
            '100': list()
        },
        'skyhook': {
            '1': list(),
            '10': list(),
            '100': list()
        }
    }

    selectivity_map = {
        '1': [('total_amount', '>', 69)],
        '10': [('total_amount', '>', 27)],
        '25': [('total_amount', '>', 19)],
        '50': [('total_amount', '>', 11)]
        # '100': None 
    }
    
    for selectivity, filter in selectivity_map.items():
        for fmt in ['parquet', 'skyhook']:
            df = dd.read_parquet('/mnt/cephfs/dataset', engine='pyarrow', filters=filter, format=fmt)
            for _ in range(5):
                s = time.time()
                df.compute()
                e = time.time()
                print(f'{fmt} {selectivity}% : ', e-s)
                data[fmt][selectivity].append(e - s)

            gc.collect()

    # create the dataframe
    data_list = list()
    for selectivity in data['parquet']:
        for latency in data['parquet'][selectivity]:
            data_list.append({
                'format': 'parquet',
                'selectivity': selectivity,
                'latency': latency
            })
    
    for selectivity in data['skyhook']:
        for latency in data['skyhook'][selectivity]:
            data_list.append({
                'format': 'skyhook',
                'selectivity': selectivity,
                'latency': latency
            })

    # plot the graph and save it
    sns_plot = sns.barplot(x='selectivity', y='latency', hue='format', data=pd.DataFrame(data_list))
    sns_plot.set_title('Query Latency')
    sns_plot.set_xlabel('Selectivity')
    sns_plot.set_ylabel('Latency (s)')
    plt.savefig(f'dask-skyhook-bench-{time.time()}.pdf')
    