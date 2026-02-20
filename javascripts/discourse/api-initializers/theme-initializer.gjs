import { apiInitializer } from "discourse/lib/api";

const kHref = "/latest?order=created"

// 解析网址中的路径和参数
const parseUrl = (url = '') => {
    let path = url.replace(/#.*$/, '')
    let query = {}
    const qIndex = path.indexOf('?')
    if (qIndex !== -1) {
        const queryBody = path.slice(qIndex + 1)
        path = path.slice(0, qIndex)
        queryBody.split('&').forEach(kv => {
            const value = kv.split('=')
            if (value.length > 1) {
                query[decodeURIComponent(value[0])] = decodeURIComponent(value[1])
            }
        })
    }
    let curDir = path
    let lastComponent = ''
    if (!path.endsWith('/')) {
        const index = path.lastIndexOf('/')
        if (index == -1) {
            lastComponent = path
        } else {
            curDir = path.slice(0, index + 1)
            lastComponent = path.slice(index + 1)
        }
    }
    return {path, query, curDir, lastComponent}
}

// 拼接路径，避免多一个斜杠
const joinPath = (a, b) => {
    const aSlash = a.endsWith('/')
    const bSlash = b.startsWith('/')
    if (aSlash && bSlash) {
        return a + b.slice(1)
    }
    if (!aSlash && !bSlash) {
        return a + '/' + b
    }
    return a + b
}

export default apiInitializer((api) => {
  api.addNavigationBarItem({
    name: "latest-created",
    displayName: '最新发表',
    href: kHref,
    before: 'latest',
    customHref: (category, args, router) => {
        if (!category && !args?.tagId) {
            return kHref
        }
        // 浏览分类或标签时，最新发表栏目的 URL 为分类路径 + `/l/` + kHref，须判断是否已存在 `/l/` 子路径
        const url = parseUrl(router.currentURL)
        if (url.curDir.endsWith('/l/')) {
            return joinPath(url.curDir, kHref)
        }
        return joinPath(url.path, '/l' + kHref)
    },
    forceActive: (category, args, router) => {
        // 判断是否为最新发表路径，并将导航链接强制设为活动状态
        const url = parseUrl(router.currentURL)
        return (url.lastComponent === "latest" && url.query.order === "created") || url.lastComponent === "latest_created"
    },
    init: (navItem) => { navItem.title = '按发表时间排序的最新话题' },
  });
});
