# claude-code-prompt-sync - Claude Code 项目指导

## 项目信息
- **项目名称**: claude-code-prompt-sync
- **项目类型**: general
- **配置时间**: Sun Jul  6 13:57:07 CST 2025
- **项目路径**: /home/damian/claude-code-prompt-sync

## 可用的Claude提示词

### 🧠 超级思考模式
```
/project:ultrathink-task <任务描述>
```
启动4个专业子代理协作分析复杂任务：
- 🏗️ 架构师代理：系统设计和架构分析
- 🔍 研究代理：技术调研和最佳实践
- 💻 编码代理：具体代码实现
- 🧪 测试代理：测试策略和质量保证

### 📝 代码审查
```
/project:code-review <文件路径或代码>
```
专业的代码审查，包括：
- 代码质量分析
- 安全性检查
- 性能优化建议
- 最佳实践建议

## MCP服务配置

当前项目已配置以下MCP服务：
- 📁 filesystem - 文件系统访问
- 🔧 git - Git仓库操作
- 🌐 fetch - HTTP请求
- 🤖 其他项目相关服务

重启Claude Code后即可使用这些服务。

## 快速命令

```bash
# 更新配置
./claude-manager.sh

# 查看项目指导
cat .claude/project-guide.md
```
