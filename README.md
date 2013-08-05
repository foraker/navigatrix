# Navigatrix

The simplest possible navigation might look something like this:
```ERB
<%= render_navigation({
  "Home"     => "/",
  "About Us" => "/about-us"
  "Blog"     => "/blog"
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

A more sophisticated configuration might look like this:
```ERB
<%= render_navigation({
  "Home" => "/",
  "Users" => {
    :path   => "/users",
    :active => [
      {path: "/my_account"},
      {path: /\/users\/\d*/},
    ]
  }
  "Sign In" => {
    :path   => "/sign_in_",
    :render => !user_signed_in?
  }
  "Sign Out" => {
    :path   => "/sign_out_",
    :render => user_signed_in?
  }
}, {:list_class => "nav", :active_class => "active-nav-item"}) %>
```

Assuming we're on the "/users/1" path, and a User is signed in, the resulting HTML will look like this:
```HTML
<ul>
  <li><a href="/">Home</a></li>
  <li class="active"><a href="/users">Users</a></li>
  <li><a href="/sign_out">Sign Out</a></li>
</ul>
```
The "Users" item is active because the path "/users/1" matches the pattern `/\/users\/\d*/`.  The item is linked because we are not on the path "/users".

## Options
:active:
  - controller: :performance_groups
  - action: :show
:children
:path
:active_class
:rendered - boolean
:unlinked
