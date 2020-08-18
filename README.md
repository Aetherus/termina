# Termina

## 实体定义

### 项目

```
{
  "id": ID,
  "name": 项目名称（必须、唯一）,
  "description": 项目描述（非必须）,
  "inserted_at": 创建时间,
  "updated_at": 修改时间
}
```

### 词条

```
{
  "id": ID,
  "project_id": 关联项目ID（必须），
  "english": 英文（必须、在项目内同一个词性唯一）,
  "chinese": 中文（必须）,
  "part_of_speech": 词性（必须，名词|动词|形容词|其他）,
  "description": 解释（非必须）,
  "inserted_at": 创建时间,
  "updated_at": 修改时间
}
```

## Phoenix WebSocket 接口：

| 名称 | 通道 | 连接/上行/下行 | 事件 | Payload | 响应 | 成功后广播事件 |
| - | project:all | 连接 | - | - | 项目列表 | - |
| - | project:<项目ID> | 连接 | - | - | 词条列表 | - |
| 创建项目 | project:all | 上行 | +project | 项目实体（不含id和时间戳） | 项目实体/异常信息 | +project |
| 创建项目 | project:all | 下行 | +project | - | 项目实体 | - |
| 删除项目 | project:all | 上行 | -project | 项目实体 | 项目实体/异常信息 | -project |
| 删除项目 | project:all | 下行 | -project | - | 项目实体 | - |
| 修改项目 | project:all | 上行 | ^project | 项目实体 | 项目实体/异常信息 | ^project |
| 修改项目 | project:all | 下行 | ^project | - | 项目实体 | - |
| 复制项目 | project:all | 上行 | ~project | `{"original_id": 原始项目ID, "new_name": 新项目名称}` | 项目实体/异常信息 | +project |
| 创建词条 | project:<项目ID> | 上行 | +term    | 词条实体（不含id和时间戳） | 词条实体/异常信息 | +term |
| 创建词条 | project:<项目ID> | 下行 | +term | - | 词条实体 | - |
| 删除词条 | project:<项目ID> | 上行 | -term | 词条实体 | 词条实体/异常信息 | -term |
| 删除词条 | project:<项目ID> | 下行 | -term | - | 词条实体 | - |
| 修改词条 | project:<项目ID> | 上行 | ^term | 词条实体 | 词条实体/异常信息 | ^term |
| 修改词条 | project:<项目ID> | 下行 | ^term | - | 词条实体 | - |

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
