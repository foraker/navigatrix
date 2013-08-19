# Navigatrix

## The Simplest Possible Navigation
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

## A More Sophisticated Configuration
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
  :active_class    => "active-nav-item",
  :html_attributes => {
    :class => "nav"
  }
}) %>
```

Assuming we're on the "/users/1" path, and a User is signed in, the resulting HTML will look like this:
```HTML
<ul class="nav">
  <li><a href="/">Home</a></li>
  <li class="active-nav-item">Users</li>
  <li><a href="/sign_in">Sign In</a></li>
</ul>
```
The "Users" item is active because the path "/users/1" matches the pattern `/\/users\/\d*/`.  The item is linked because we are not on the path "/users".

## List Item Configuration Options
### `:path`
Specifies where the navigation item should link to.

### `:active_states`
An array of state specification hashes used to control when a list item is considered "active".  By default, when an item is active, it receives an HTML class of "active". For example:
```Ruby
active_states: [
  {controller: "users", actions: ["index"]},
  {path: "/my-account"}
]
```
The first state specification dictates that the item will be active when the current controller is the `UsersController` and the current controller action is `index`.  If we wanted the item to be active for any `UsersController` action, the specification should be `{controller: "users"}`.

The second state specification dictates that the item will be active with the current path is "/my-account".  `:path` can be a string or regular expression.

### `:unlinked_states`
Also an array of state specification hashes (like `:active_states`).  The state specifications determine if the item should be linked.  By default, the item is unlinked if the current path is the same as the item path.  The `:unlinked_states` option can be used to override this behavior.

### `:html_attributes`
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

### `:children`
Used for creating nested navigations.  The `:children` should contain a navigation configuration.
```Ruby
"Parent" => {
  :path => "/parent_path"
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

### `:render?`
Determines if the navigation item is rendered.

## List Configuration Options
### `:html_attributes`
HTML attributes added to an the list.

### `:active_class`
Determines which HTML class is applied to list items when the item is active.

### `:inactive_class`
Determines which HTML class is applied to list items when the item is *not* active.
