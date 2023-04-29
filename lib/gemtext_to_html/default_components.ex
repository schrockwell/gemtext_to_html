defmodule GemtextToHTML.DefaultComponents do
  @moduledoc """
  Renders very basic unstyled HTML elements.

  This exists primarily for simple use-cases, testing, and as a reference implementation.

  ## Options

  - `:empty_lines` - how to render empty lines of text:

    - `:ignore` - do not render empty lines (default)
    - `:br` - render empty lines as `<br />`
    - `:p` - render empty lines as `<p />`
  """

  @behaviour GemtextToHTML.Components
  import Phoenix.Component

  def h1(assigns), do: ~H"<h1><%= @text %></h1>"
  def h2(assigns), do: ~H"<h2><%= @text %></h2>"
  def h3(assigns), do: ~H"<h3><%= @text %></h3>"

  def link(assigns) do
    assigns = if assigns.text, do: assigns, else: Map.put(assigns, :text, assigns.to)

    ~H"""
    <p>
      <a href={@to}><%= @text %></a>
    </p>
    """
  end

  def list(assigns) do
    ~H"""
    <ul>
      <%= for item <- @items do %>
        <li><%= item %></li>
      <% end %>
    </ul>
    """
  end

  def quote(assigns) do
    ~H"""
    <blockquote><%= @text %></blockquote>
    """
  end

  def pre(assigns), do: ~H"<pre><%= @text %></pre>"

  def text(%{text: "", opts: %{empty_lines: :br}} = assigns), do: ~H"<br />"
  def text(%{text: "", opts: %{empty_lines: :p}} = assigns), do: ~H"<p />"
  def text(%{text: ""} = assigns), do: ~H""
  def text(assigns), do: ~H"<p><%= @text %></p>"
end
