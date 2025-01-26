# sklearn(sickit-learn)

python で利用できるデータ分析や機械学習のためのライブラリの一つ

## KMeans によるクラスタリング

```Python
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler

# 値の正規化
# dataにはpandasで読み込んだDataFrameが入っている
clustering_sc = StandardScaler().fit_transform(data)

# クラスタ数=4
# クラスタリングを行った結果を"cluster"というフィールドに格納
# 列"cluster"には0～4の値のどれかが入る
kmeans = KMeans(n_clusters=5, random_state=0)
clusters = kmeans.fit(clustering_sc)
clustering['cluster'] = clusters.labels_
```

## t-SNE による次元削減

```Python
from sklearn.manifold import TSNE

# n_componentsは次元数？ 2次元だと平面に可視化できる
tsne = TSNE(n_components=2, random_state=0)
x = tsne.fit_transform(clustering_sc)
tsne_df = pd.DataFrame(x)
tsne_df['cluster'] = clustering['cluster']
tsne_df['axis_0', 'axis_1', 'cluster']

# 可視化
import seaborn as sns
sns.scatterplot(x='axis_0', y='axis_1', hue='cluster', data=tsne_df)
```
