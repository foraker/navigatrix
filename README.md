# Navigatrix
[![Build Status](https://api.travis-ci.org/foraker/navigatrix.png?branch=master)](http://travis-ci.org/foraker/navigatrix)
[![Code Climate](https://codeclimate.com/github/foraker/navigatrix.png)](https://codeclimate.com/github/foraker/navigatrix)

Navigation generation for Rails and Sinatra.

## Installation
Add `gem "navigatrix"` to your Gemfile and run `bundle install`.

### The Simplest Possible Navigation
```ERB
<%= render_navigation({
  "Home"     => "/",
  "About Us" => "/about-us",
  "Blog"     => "/blog",
  "Contact"  => "/contact"
}) %>
```
Assuming we're on the "/about-us" path, the resulting HTML will look like this:
```HTML
<ul>
  <li><a href="/">Home</a></li>
  <li class="active">About Us</li>
  <li><a href="/blog">Blog</a></li>
  <li><a href="/contact">Contact</a></li>
</ul>
```

### A More Sophisticated Configuration
```ERB
<%= render_navigation({
  "Home" => "/",
  "Users" => {
    :path   => "/users",
    :active_states => [
      {:path => "/my_account"},
      {:path  => /\/users\/\d*/},
    ]
  },
  "Sign In" => {
    :path   => "/sign_in",
    :render? => !user_signed_in?
  },
  "Sign Out" => {
    :path   => "/sign_out",
    :render? => user_signed_in?
  }
}, {
  :item => {
    :active_class => "active-nav-item"
  },
  :list => {
    :html_attributes => {
      :class => "nav"
    }
  }
}) %>
```

Assuming we're on the "/users/1" path, and a User is signed in, the resulting HTML will look like this:
```HTML
<ul class="nav">
  <li><a href="/">Home</a></li>
  <li class="active-nav-item"><a href="/users">Users</a></li>
  <li><a href="/sign_out">Sign Out</a></li>
</ul>
```
The "Users" item is active and not linked because the path "/users/1" matches the pattern `/\/users\/\d*/`.  The "Home" item is linked because we are not on the path "/".

## List Configuration Options
List configuration options are supplied via the `:list` option when rendering a navigation.  For example,

```Ruby
render_navigation(config, {
  list: {
    html_attributes: {
      class: "nav"
    }
  }
})
```

A list accepts the following configuration options:

##### `:html_attributes`
HTML attributes added to an the list.

## List Item Configuration Options

List item configuration options can be supplied to all list items or a single list item.  Supply options to a single list item via the navigation configuration.

```Ruby
render_navigation({
  "Home" => {
    path: "/",
    active_class: "home-active"
  }
})
```

The following options are supported.

##### `:path`
Specifies where the navigation item should link to.

##### `:active_states`
An array of state specification hashes used to control when a list item is considered "active".  By default, when an item is active, it receives an HTML class of "active". For example:
```Ruby
active_states: [
  {controller: "users", actions: ["index"]},
  {path: "/my-account"}
]
```
The first state specification dictates that the item will be active when the current controller is the `UsersController` and the current controller action is `index`.  If we wanted the item to be active for any `UsersController` action, the specification should be `{controller: "users"}`.

The second state specification dictates that the item will be active with the current path is "/my-account".  `:path` can be a string or regular expression.

##### `:unlinked_states`
Also an array of state specification hashes (like `:active_states`).  The state specifications determine if the item should be linked.  By default, the item is unlinked if the current path is the same as the item path.  The `:unlinked_states` option can be used to override this behavior.

##### `:html_attributes`
HTML attributes added to an item.
```Ruby
  "Item 3" => {
    :path => "/item_path"
    :html_attributes => {:id => "nav-3"}
  }
```
Results in the following HTML.
```HTML
<li id="nav-3"><a href="item_path">Item 3</a></li>
```

##### `:children`
Used for creating nested navigations.  The `:children` should contain a navigation configuration.
```Ruby
"Parent" => {
  :path => "/parent_path",
  :children => {
    "Child 1" => "/child_1_path",
    "Child 2" => {
      :path => "/child_2_path",
      :children => {
        "Grandchild" => "/grandchild_path"
      }
    }
  }
}
```
Results in the following HTML.
```HTML
<ul>
  <li>
    <a href="/parent_path">Parent</a>
    <ul>
      <li><a href="/child_1_path">Child 1</a></li>
      <li>
        <a href="/child_2_path">Child 2</a>
        <ul>
          <li href="/grandchild_path">Grandchild</li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
```

##### `:render?`
Determines if the navigation item is rendered.

### Supplying options to all list items
List configuration options are supplied via the `:item` option when rendering a navigation.  For example,
```Ruby
render_navigation(config, {
  item: {
    active_class: "active-item"
  }
})
```

Supported options are:

##### `:active_class`
Determines which HTML class is applied to list items when the item is active.

##### `:inactive_class`
Determines which HTML class is applied to list items when the item is *not* active.

`active_class`, `inactive_class`, `html_attributes`.

## Building Custom List Renderers

To change the default list rendering from \<ul> tags to \<section> tags with an id of "nav", create a custom list renderer:

```Ruby
Navigatrix.register_list_renderer(:my_custom_list) do |renderer|
  renderer.wrapper do |items, html_attributes|
    content_tag(:section, items, html_attributes.merge_attribute(:id, "nav"))
  end
end
```

```ERB
<%= render_navigation({
  "Home"     => "/",
  "About Us" => "/about-us",
}, {
  list: {renderer: :my_custom_list}
}) %>
```

## Building Custom Item Renderers

If the basic list and and item configuration, custom renders can be registered.

For example, to add change the default item rendering from \<li> tags to \<p> tags, create a custom item renderer:

```Ruby
Navigatrix.register_item_renderer(:my_custom_item) do |renderer|
  renderer.wrapper do |content, children, html_attributes|
    content(:p, content + children, html_attributes)
  end
end
```

```ERB
<%= render_navigation({
  "Home"     => "/",
  "About Us" => "/about-us",
}, {
  item: {renderer: :my_custom_item}
}) %>
```

#### All item rendering options

`wrapper` - wraps item content - accepts `content, children, html_attributes`

`linked` - content when the item is linked - accepts `name, path`

`unlinked` - content when the item is not linked - accepts `name, path`

`html_attributes` - HTML attributes for the item

`children_options` - attributes passed to the child list

## About Foraker Labs

![Foraker Logo](http://assets.foraker.com/attribution_logo.png)

Foraker Labs builds exciting web and mobile apps in Boulder, CO. Our work powers a wide variety of businesses with many different needs. We love open source software, and we're proud to contribute where we can. Interested to learn more? [Contact us today](https://www.foraker.com/contact-us).

This project is maintained by Foraker Labs. The names and logos of Foraker Labs are fully owned and copyright Foraker Design, LLC.
