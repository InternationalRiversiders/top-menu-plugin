import { withPluginApi } from "discourse/lib/plugin-api";
import { setDefaultHomepage } from "discourse/lib/utilities";
import { i18n } from "discourse-i18n";

const LATEST_CREATED_HOMEPAGE_ID = 9;
const LATEST_CREATED_FILTER = "latest_created";

function initializeLatestCreatedHomepage(api) {
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
