# discourse-latest-created-homepage

为 Discourse 增加“最新发表”能力（按话题创建时间排序），包含默认首页选项和顶部导航入口。

## 实现说明

- 后端：`plugin.rb` 注册 `latest_created` 过滤器并扩展 `TopicQuery`
- 前端：`assets/javascripts/discourse/initializers/latest-created-homepage.gjs`
  - 扩展“用户偏好 -> 界面”中的默认首页选项
  - 注入顶部导航项“最新发表”
- 国际化：`config/locales/*.yml`

## 功能

- 新增过滤器：`latest_created`
- 新增用户默认首页选项：`最新发表`
- 新增顶部导航项：`最新发表`（链接到 `/latest?order=created`）
- 该选项不会覆盖原有 `latest`（最新回复）行为

## 安装

1. 将此目录放到 `discourse/plugins/discourse-latest-created-homepage`
2. 重建 Discourse 容器

## 验证

1. 打开 `用户偏好设置 -> 界面`
2. 在“默认首页”里选择“最新发表”
3. 访问首页顶部导航，确认出现“最新发表”
4. 点击“最新发表”，应进入按创建时间排序的话题列表（`/latest?order=created`）
5. 将默认首页设置为“最新发表”后访问站点根路径 `/`，应落到相同排序结果

## 常见问题

- 后台“已安装插件”看不到仓库名：
  插件显示的是 `plugin.rb` 中的 `# name`（`discourse-latest-created-homepage`），不是仓库目录名。
- 改了前端代码但导航没出现：
  需要执行 `./launcher rebuild app` 重新编译资源，并在浏览器强制刷新（`Ctrl+F5`）。
