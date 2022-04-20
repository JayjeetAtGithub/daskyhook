import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt

if __name__ == "__main__":
    # 10GbE
    pq = [5.896867275238037, 5.982793569564819, 5.965559005737305]
    sk = [13.735283374786377, 13.548393964767456, 12.947990655899048]

    data = list()

    for x in pq:
        data.append({
            'format': 'pq',
            'latency': x,
            'bandwidth': '10GbE'
        })

    for x in sk:
        data.append({
            'format': 'sk',
            'latency': x,
            'bandwidth': '10GbE'
        })

    # 1GbE
    pq = [415.1436297893524, 314.97357296943665, 392.31217789649963]
    sk = [54.895158767700195, 67.4822244644165, 59.04222297668457]

    for x in pq:
        data.append({
            'format': 'pq',
            'latency': x,
            'bandwidth': '1GbE'
        })

    for x in sk:
        data.append({
            'format': 'sk',
            'latency': x,
            'bandwidth': '1GbE'
        })

    df = pd.DataFrame(data)
    x = sns.barplot(x="bandwidth", y="latency",  hue="format", data=df)
    plt.savefig("plot.pdf")