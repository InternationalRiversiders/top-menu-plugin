# discourse-latest-created-homepage

为 Discourse 增加一个“最新发表”默认首页选项（`/latest_created`，按话题创建时间排序）。

## 实现说明

- 后端：`plugin.rb` 注册 `latest_created` 过滤器并扩展 `TopicQuery`
- 前端：`assets/javascripts/discourse/initializers/latest-created-homepage.gjs` 扩展“用户偏好 -> 界面”中的默认首页选项
- 国际化：`config/locales/*.yml`

## 功能

- 新增过滤器：`latest_created`
- 新增用户默认首页选项：`最新发表`
- 该选项不会覆盖原有 `latest`（最新回复）行为

## 安装

1. 将此目录放到 `discourse/plugins/discourse-latest-created-homepage`
2. 重建 Discourse 容器

## 验证

1. 打开 `用户偏好设置 -> 界面`
2. 在“默认首页”里选择“最新发表”
3. 访问站点根路径 `/`，应落到按创建时间排序的话题列表
