# matplot

グラフの可視化を行える python のライブラリ

## import

```Python
import matplotlib.pyplot as plt
%matplotlib inline
```

## pandas 利用時

- データフレームからグラフを生成することも可能

```Python
data = pd.read_csv('filename.csv')
data.groupby('index').sum().plot()
```

### 折れ線グラフ

```Python
plt.plot(data)
```

### ヒストグラム

```Python
plt.hist(data)
```
