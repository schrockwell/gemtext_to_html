defmodule GemtextToHTML do
  @moduledoc """
  Render Gemtext as HTML.

  Phoenix function components are used to transform individual Gemtext elements to HTML. Simply implement the
  `GemtextToHTML.Components` behaviour and pass it to the `:components` option of `render/2`.

  ## Example

      gemtext = \"\"\"
      # Hello, world

      * this is a list
      * indeed

      pretty neat
      \"\"\"

      GemtextToHTML.render_to_string(gemtext, components: GemtextToHTML.DefaultComponents)
      # => "<h1>Hello, world</h1><ul><li>this is a list</li><li>indeed</li></ul><p>pretty neat</p>"

  """
  @default_opts %{
    components: GemtextToHTML.DefaultComponents
  }

  @initial_state %{
    prev_el: nil,
    lis: []
  }

  @doc """
  Returns a safe iolist of HTML rendered from a gemtext document.

  ## Options

  - `:components` - the `GemtextToHTML.Components` callback module used to render each element; defaults to `GemtextToHTML.DefaultComponents`

  Any additional options may be specified, which will be passed to the components as a map in the `@opts` assign.
  """
  @spec render(String.t(), keyword) :: {:safe, iolist()}
  def render(gemtext, opts \\ []) do
    {:safe, render_to_iolist(gemtext, opts)}
  end

  @doc """
  Returns an iolist of HTML rendered from a gemtext document.

  See `render/2` for options.
  """
  @spec render_to_iolist(String.t(), keyword) :: iolist()
  def render_to_iolist(gemtext, opts \\ []) do
    opts = Map.merge(@default_opts, Map.new(opts))

    gemtext
    |> Gemtext.parse()
    |> run(opts)
  end

  @doc """
  Returns a string of HTML rendered from a gemtext document.

  See `render/2` for options.
  """
  @spec render_to_string(String.t(), keyword) :: String.t()
  def render_to_string(gemtext, opts \\ []) do
    gemtext
    |> render_to_iolist(opts)
    |> :erlang.iolist_to_binary()
  end

  defp run(nodes, opts, state \\ @initial_state, rendered \\ [])

  defp run([], _opts, _state, rendered) do
    rendered
    |> Enum.reverse()
    |> Enum.map(fn rendered ->
      rendered
      |> Phoenix.HTML.html_escape()
      |> then(fn {:safe, iodata} -> iodata end)
    end)
  end

  # Render the list after the final sequential list item
  defp run([el | _] = rest, opts, %{prev_el: :li} = state, rendered) when elem(el, 0) != :li do
    rendered = [opts.components.list(%{items: Enum.reverse(state.lis), opts: opts}) | rendered]
    run(rest, opts, %{state | prev_el: nil, lis: []}, rendered)
  end

  # Render basic text elements
  for simple_element <- [:h1, :h2, :h3, :quote, :text, :pre] do
    defp run([{unquote(simple_element), text} | rest], opts, state, rendered) do
      rendered = [
        opts.components.unquote(simple_element)(%{text: trim(text), opts: opts}) | rendered
      ]

      run_next(unquote(simple_element), rest, opts, state, rendered)
    end
  end

  # Render a link
  defp run([{:link, %{to: to}, text} | rest], opts, state, rendered) do
    rendered = [opts.components.link(%{text: trim(text), to: to, opts: opts}) | rendered]
    run_next(:link, rest, opts, state, rendered)
  end

  # Render preformatted text with a title
  defp run([{:pre, %{title: title}, text} | rest], opts, state, rendered) do
    rendered = [opts.components.pre(%{text: trim(text), title: title, opts: opts}) | rendered]
    run_next(:pre, rest, opts, state, rendered)
  end

  # Accumulate a list item (don't render anything yet)
  defp run([{:li, text} | rest], opts, state, rendered) do
    run_next(:li, rest, opts, %{state | lis: [text | state.lis]}, rendered)
  end

  # Ignore anything weird
  defp run([unexpected | rest], opts, state, rendered) do
    run_next(elem(unexpected, 0), rest, opts, state, rendered)
  end

  defp run_next(el, rest, opts, state, rendered) do
    run(rest, opts, %{state | prev_el: el}, rendered)
  end

  defp trim(text) when is_binary(text), do: String.trim(text)
  defp trim(value), do: value
end
