# GemtextToHTML

Render Gemtext as HTML.

Phoenix function components are used to transform individual Gemtext elements to HTML. Simply implement the
`GemtextToHTML.Components` behaviour and pass it to the `:components` option of `render/2`.

## Example

First, define a callback module to render the components.

```elixir
defmodule MyApp.MyComponents do
  @behaviour GemtextToHTML.Components
  import Phoenix.Component

  def h1(assigns) do
    ~H"""
    <h1 class="text-lg font-bold"><%= @text %></h1>
    """
  end

  # ...and so on...
end
```

Then, pass that module as the `:components` option when rendering the Gemtext.

```elixir
gemtext = """
# Hello, world

* this is a list
* indeed

pretty neat
"""

GemtextToHTML.render_to_string(gemtext, components: MyApp.MyComponents)
# => "<h1 class="text-lg font-bold">Hello, world</h1>" <> ...
```

## Compatibility

Phoenix LiveView 0.18.x or greater is required.

## Installation

The package can be installed by adding `gemtext_to_html` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gemtext_to_html, "~> 0.1.0"}
  ]
end
```
