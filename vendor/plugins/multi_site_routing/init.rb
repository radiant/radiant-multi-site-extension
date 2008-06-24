# Putting these in a plugin is hackish, but it prevents
# them from getting reloaded in dev mode (which is bad)

ActionController::Routing::RouteSet.send :include, MultiSite::RouteSetExtensions
ActionController::Routing::Route.send :include, MultiSite::RouteExtensions