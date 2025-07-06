# MCP 配置说明

## 配置文件

### ultimate.json
包含完整的MCP服务器配置，支持：

- **filesystem** - 文件系统操作
- **git** - Git仓库管理
- **context7** - 上下文检索和文档查询
- **sequential-thinking** - 序列化思维推理
- **fetch** - 网络请求和内容获取
- **browser-tools** - 浏览器工具和自动化
- **puppeteer** - 浏览器自动化
- **postgres** - PostgreSQL数据库
- **sqlite** - SQLite数据库
- **memory** - 知识图谱持久化内存
- **brave-search** - Brave搜索API
- **everything** - 通用工具集
- **magic** - 21st.dev AI UI组件生成器

## 环境变量配置

项目根目录的 `.env` 文件包含：

```bash
# 21st.dev Magic API Key
MAGIC_API_KEY=your-api-key-here

# Brave Search API Key (可选)
BRAVE_API_KEY=your-brave-api-key-here

# PostgreSQL连接字符串 (可选)
POSTGRES_CONNECTION_STRING=postgresql://username:password@localhost:5432/database
```

## 使用方法

1. **复制配置**：将 `ultimate.json` 内容复制到Claude Code的MCP配置中
2. **设置环境变量**：确保 `.env` 文件中的API密钥正确
3. **重启Claude Code**：让配置生效

## Magic MCP 使用

配置完成后，可以在Claude对话中使用：

```
/ui 创建一个现代化的导航栏
/ui 生成一个响应式的卡片组件
/ui 制作一个带动画的按钮
```

## 注意事项

- `.env` 文件已添加到 `.gitignore`，不会被提交到版本控制
- Magic MCP需要有效的API密钥才能正常工作
- 其他服务如Brave Search和PostgreSQL也需要相应的配置
