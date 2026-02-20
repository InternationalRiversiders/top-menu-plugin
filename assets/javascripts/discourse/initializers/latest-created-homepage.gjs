import { withPluginApi } from "discourse/lib/plugin-api";
import { setDefaultHomepage } from "discourse/lib/utilities";
import { i18n } from "discourse-i18n";

const LATEST_CREATED_HOMEPAGE_ID = 9;
const LATEST_CREATED_FILTER = "latest_created";
const LATEST_CREATED_HREF = "/latest?order=created";

function parseUrl(url = "") {
  let path = url.replace(/#.*$/, "");
  const query = {};
  const qIndex = path.indexOf("?");

  if (qIndex !== -1) {
    const queryBody = path.slice(qIndex + 1);
    path = path.slice(0, qIndex);

    queryBody.split("&").forEach((kv) => {
      const pair = kv.split("=");
      if (pair.length > 1) {
        query[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1]);
      }
    });
  }

  let curDir = path;
  let lastComponent = "";

  if (!path.endsWith("/")) {
    const index = path.lastIndexOf("/");
    if (index === -1) {
      lastComponent = path;
    } else {
      curDir = path.slice(0, index + 1);
      lastComponent = path.slice(index + 1);
    }
  }

  return { path, query, curDir, lastComponent };
}

function joinPath(a, b) {
  const aSlash = a.endsWith("/");
  const bSlash = b.startsWith("/");

  if (aSlash && bSlash) {
    return a + b.slice(1);
  }
  if (!aSlash && !bSlash) {
    return `${a}/${b}`;
  }

  return a + b;
}

function latestCreatedHref(category, args, router) {
  if (!category && !args?.tagId) {
    return LATEST_CREATED_HREF;
  }

  const url = parseUrl(router.currentURL);
  if (url.curDir.endsWith("/l/")) {
    return joinPath(url.curDir, LATEST_CREATED_HREF);
  }

  return joinPath(url.path, `/l${LATEST_CREATED_HREF}`);
}

function initializeLatestCreatedHomepage(api) {
  api.addNavigationBarItem({
    name: LATEST_CREATED_FILTER,
    displayName: i18n("filters.latest_created.title"),
    href: LATEST_CREATED_HREF,
    before: "latest",
    customHref: latestCreatedHref,
    forceActive: (_category, _args, router) => {
      const url = parseUrl(router.currentURL);
      return (
        (url.lastComponent === "latest" && url.query.order === "created") ||
        url.lastComponent === LATEST_CREATED_FILTER
      );
    },
    init: (navItem) => {
      navItem.title = i18n("filters.latest_created.help");
    },
  });

  api.modifyClass(
    "controller:preferences/interface",
    (Superclass) =>
      class extends Superclass {
        homeChanged() {
          if (
            Number(this.model?.user_option?.homepage_id) ===
            LATEST_CREATED_HOMEPAGE_ID
          ) {
            setDefaultHomepage(LATEST_CREATED_FILTER);
            return;
          }

          super.homeChanged(...arguments);
        }

        get userSelectableHome() {
          const result = [...(super.userSelectableHome || [])];

          if (
            !result.some(
              (item) => Number(item?.value) === LATEST_CREATED_HOMEPAGE_ID
            )
          ) {
            result.push({
              name: i18n("filters.latest_created.title"),
              value: LATEST_CREATED_HOMEPAGE_ID,
            });
          }

          return result;
        }
      }
  );
}

export default {
  name: "latest-created-homepage",

  initialize() {
    withPluginApi(initializeLatestCreatedHomepage);
  },
};
