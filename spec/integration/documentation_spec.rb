require "spec_helper"

describe "documentation" do
  let(:request) do
    double({
      env: {}
    })
  end

  let(:render_context) do
    double({
      request: request
    })
  end

  def render_navigation(configuration, options = {})
    Navigatrix::Renderer.new(configuration, options.merge(render_context: render_context)).render
  end

  it "renders a basic navigation" do
    request.stub(env: {
      "PATH_INFO" => "/about-us"
    })
    rendered = render_navigation({
      "Home"     => "/",
      "About Us" => "/about-us",
      "Blog"     => "/blog",
      "Contact"  => "/contact"
    })

    desired = <<-HTML
      <ul>
        <li><a href="/">Home</a></li>
        <li class="active">About Us</li>
        <li><a href="/blog">Blog</a></li>
        <li><a href="/contact">Contact</a></li>
      </ul>
    HTML

    rendered.should match_html(desired)
  end

  it "renders a more sophisticated nav" do
    render_context.stub(controller_name: "users")
    request.stub(env: {
      "PATH_INFO" => "/users/1"
    })

    rendered = render_navigation({
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
        :render? => false
      },
      "Sign Out" => {
        :path   => "/sign_out",
        :render? => true
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
    })

    desired = <<-HTML
      <ul class="nav">
        <li><a href="/">Home</a></li>
        <li class="active-nav-item"><a href="/users">Users</a></li>
        <li><a href="/sign_out">Sign Out</a></li>
      </ul>
    HTML

    rendered.should match_html(desired)
  end

  it "accepts item options" do
    render_context.stub(controller_name: "users")
    request.stub(env: {
      "PATH_INFO" => "/users"
    })

    rendered = render_navigation({
      "Users"   => "/users",
      "Clients" => "/clients"
    }, {
      item: {
        :active_class   => "custom-active",
        :inactive_class => "custom-inactive",
        :html_attributes => {
          "class"     => "nav-item",
          "data-item" => "nav"
        }
      }
    })

    rendered.should match_html <<-HTML
      <ul>
        <li class="nav-item custom-active" data-item="nav">Users</li>
        <li class="nav-item custom-inactive" data-item="nav"><a href="/clients">Clients</a></li>
      </ul>
    HTML
  end

  it "accepts item options on each item" do
    render_context.stub(controller_name: "users")
    request.stub(env: {
      "PATH_INFO" => "/users"
    })

    rendered = render_navigation({
      "Users" => {
        :path   => "/users",
        :active_class => "custom-active"
      },
      "Clients" => {
        :path   => "/clients",
        :inactive_class => "custom-inactive"
      }
    })

    rendered.should match_html <<-HTML
      <ul>
        <li class="custom-active">Users</li>
        <li class="custom-inactive"><a href="/clients">Clients</a></li>
      </ul>
    HTML
  end
end

RSpec::Matchers.define :match_html do |expected|
  match do |actual|
    clean(expected) == clean(actual)
  end

  failure_message_for_should do |actual|
    "expected that #{clean(actual)} to equal #{clean(expected)}"
  end

  def clean(text)
    text.strip.gsub("\n", "").gsub(/(?<=\>)\s+?(?=\<)/, "")
  end
end
