import time
import dask.dataframe as dd
from dask.distributed import Client
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

if __name__ == "__main__":
    # connect to the client
    client = Client("tcp://10.10.1.1:8786")
    print("Connected to Dask Cluster: ", client)
    
    # create the dataset
    data = {
        'pq': {
            '1': list(),
            '10': list(),
            '100': list()
        },
        'sk': {
            '1': list(),
            '10': list(),
            '100': list()
        }
    }
    
    # start the queries
    df = dd.read_parquet('/mnt/cephfs/dataset', engine='pyarrow', filters=[('total_amount', '>', 69)], format='parquet')
    for _ in range(5):
        s = time.time()
        df.compute()
        e = time.time()
        data['pq']['1'].append(e - s)

    df = dd.read_parquet('/mnt/cephfs/dataset', engine='pyarrow', filters=[('total_amount', '>', 69)], format='skyhook')
    for _ in range(5):
        s = time.time()
        df.compute()
        e = time.time()
        data['sk']['1'].append(e - s)

    df = dd.read_parquet('/mnt/cephfs/dataset', engine='pyarrow', filters=[('total_amount', '>', 27)], format='parquet')
    for _ in range(5):
        s = time.time()
        df.compute()
        e = time.time()
        data['pq']['10'].append(e - s)

    df = dd.read_parquet('/mnt/cephfs/dataset', engine='pyarrow', filters=[('total_amount', '>', 27)], format='skyhook')
    for _ in range(5):
        s = time.time()
        df.compute()
        e = time.time()
        data['sk']['10'].append(e - s)

    df = dd.read_parquet('/mnt/cephfs/dataset', engine='pyarrow', format='parquet')
    for _ in range(5):
        s = time.time()
        df.compute()
        e = time.time()
        data['pq']['100'].append(e - s)

    df = dd.read_parquet('/mnt/cephfs/dataset', engine='pyarrow', format='skyhook')
    for _ in range(5):
        s = time.time()
        df.compute()
        e = time.time()
        data['sk']['100'].append(e - s)


    # create the dataframe
    data_list = list()
    for selectivity in data['pq']:
        for latency in data['pq'][selectivity]:
            data_list.append({
                'format': 'parquet',
                'selectivity': selectivity,
                'latency': latency
            })
    
    for selectivity in data['sk']:
        for latency in data['sk'][selectivity]:
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
    