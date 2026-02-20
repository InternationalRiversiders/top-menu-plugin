# frozen_string_literal: true

# name: discourse-latest-created-homepage
# about: Adds a "latest created" homepage option for user preferences.
# version: 0.1
# authors: Jackzhang144

module ::DiscourseLatestCreatedHomepage
  PLUGIN_NAME = "discourse-latest-created-homepage"
  FILTER = :latest_created
  HOMEPAGE_ID = 9

  module TopicQueryExtension
    def list_latest_created
      create_list(:latest_created, {}, latest_results(order: "created"))
    end
  end
end

filter = DiscourseLatestCreatedHomepage::FILTER
Discourse.filters << filter unless Discourse.filters.include?(filter)
Discourse.anonymous_filters << filter unless Discourse.anonymous_filters.include?(filter)
Discourse.top_menu_items << filter unless Discourse.top_menu_items.include?(filter)
Discourse.anonymous_top_menu_items << filter unless Discourse.anonymous_top_menu_items.include?(filter)

after_initialize do
  UserOption::HOMEPAGES[DiscourseLatestCreatedHomepage::HOMEPAGE_ID] =
    DiscourseLatestCreatedHomepage::FILTER.to_s

  if !(TopicQuery < DiscourseLatestCreatedHomepage::TopicQueryExtension)
    TopicQuery.prepend(DiscourseLatestCreatedHomepage::TopicQueryExtension)
  end
end
