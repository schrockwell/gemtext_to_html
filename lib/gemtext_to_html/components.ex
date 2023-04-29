defmodule GemtextToHTML.Components do
  use Phoenix.Component

  @moduledoc """
  Callback module to render HTML components from gemtext elements.

  ## Example

      defmodule MyApp.MyComponents do
        @behaviour GemtextToHTML.Components
        import Phoenix.Component

        def h1(assigns) do
          ~H\"\"\"
          <h1 class="text-lg font-bold"><%= @text %></h1>
          \"\"\"
        end

        # ...
      end
  """

  @doc """
  Renders a heading.

  ## Assigns

  - `:text` - the text content
  - `:opts` - a map of user-specified options
  """
  @callback h1(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  @doc """
  Renders a sub-heading.

  ## Assigns

  - `:text` - the text content
  - `:opts` - a map of user-specified options
  """
  @callback h2(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  @doc """
  Renders a sub-sub-heading.

  ## Assigns

  - `:text` - the text content
  - `:opts` - a map of user-specified options
  """
  @callback h3(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  @doc """
  Renders a link.

  ## Assigns

  - `:text` - the text content (may be `nil`)
  - `:opts` - a map of user-specified options
  - `:to` - the URL content
  """
  @callback link(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  @doc """
  Renders an unordered list.

  ## Assigns

  - `:items` - a list of strings for each list item
  - `:opts` - a map of user-specified options
  """
  @callback list(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  @doc """
  Renders a block quote.

  ## Assigns

  - `:text` - the text content
  - `:opts` - a map of user-specified options
  """
  @callback quote(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  @doc """
  Renders preformatted text.

  ## Assigns

  - `:text` - the text content
  - `:opts` - a map of user-specified options
  - `:title` - optional; the title/language specified on the same line as the first three backticks,
  """
  @callback pre(assigns :: map()) :: Phoenix.LiveView.Rendered.t()

  @doc """
  Renders a line of text.

  ## Assigns

  - `:text` - the text content
  - `:opts` - a map of user-specified options
  """
  @callback text(assigns :: map()) :: Phoenix.LiveView.Rendered.t()
end
