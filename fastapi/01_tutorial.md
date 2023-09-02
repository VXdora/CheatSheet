# FastAPIの基本

## routerの設定

main.pyに全てを書いてもいいが，main.pyが肥大化するため，機能ごとに分けるのが基本．
routerは，どこのURLにアクセスしたとき，どんな操作をするのかを記述．

routerA.py
```python
from fastapi import APIRouter

router = APIRouter()

@router.get("/tasks")
async def list_tasks():
    pass

@router.get("/task/{id}")
async def get_task(id):
    pass
```

getの他，以下が指定可能．
- get
- post
- put
- delete

続いて，main.pyにルーティング設定をしていく．
```python
from fastapi import FastAPI
import routerA

app = FastAPI()
app.include_router(routerA.router)
```

## スキーマの定義
