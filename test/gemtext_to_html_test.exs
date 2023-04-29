defmodule GemtextToHtmlTest do
  use ExUnit.Case
  doctest GemtextToHTML

  defp gemtext_to_fragment(gemtext, opts \\ []) do
    gemtext
    |> GemtextToHTML.render_to_string(opts)
    |> Floki.parse_fragment!()
  end

  defp floki_text(frag, selector) do
    frag |> Floki.find(selector) |> Enum.map(&Floki.text/1)
  end

  test "render/2 returns a safe iolist" do
    # GIVEN
    gemtext = """
    hello, world
    I'm just this guy, you know?
    """

    # WHEN
    result = GemtextToHTML.render(gemtext)

    # THEN
    assert {:safe,
            [
              ["<p>", "hello, world", "</p>"],
              ["<p>", [[[], "I" | "&#39;"] | "m just this guy, you know?"], "</p>"],
              [""]
            ]} == result
  end

  test "render_to_iolist/2 returns an iolist" do
    # GIVEN
    gemtext = """
    hello, world
    I'm just this guy, you know?
    """

    # WHEN
    result = GemtextToHTML.render_to_iolist(gemtext)

    # THEN
    assert [
             ["<p>", "hello, world", "</p>"],
             ["<p>", [[[], "I" | "&#39;"] | "m just this guy, you know?"], "</p>"],
             [""]
           ] == result
  end

  test "render_to_string/2 returns an string" do
    # GIVEN
    gemtext = """
    hello, world
    I'm just this guy, you know?
    """

    # WHEN
    result = GemtextToHTML.render_to_string(gemtext)

    # THEN
    assert "<p>hello, world</p><p>I&#39;m just this guy, you know?</p>" == result
  end

  test "headings can be rendered" do
    # GIVEN
    gemtext = """
    # Heading 1
    ## Heading 2
    ### Heading 3
    """

    # WHEN
    frag = gemtext_to_fragment(gemtext)

    # THEN
    assert frag |> Floki.find("h1") |> Floki.text() == "Heading 1"
    assert frag |> Floki.find("h2") |> Floki.text() == "Heading 2"
    assert frag |> Floki.find("h3") |> Floki.text() == "Heading 3"
  end

  test "links can be rendered" do
    # GIVEN
    gemtext = """
    => /foo
    => /bar bat
    => //hello world
    """

    # WHEN
    frag = gemtext_to_fragment(gemtext)

    # THEN
    assert Floki.find(frag, "p:nth-of-type(1) > a") == [{"a", [{"href", "/foo"}], ["/foo"]}]
    assert Floki.find(frag, "p:nth-of-type(2) > a") == [{"a", [{"href", "/bar"}], ["bat"]}]
    assert Floki.find(frag, "p:nth-of-type(3) > a") == [{"a", [{"href", "//hello"}], ["world"]}]
  end

  test "lists can be rendered" do
    # GIVEN
    gemtext = """
    hello world

    * item 1
    * item 2
    * item 3

    something

    * item 1a
    * item 1b
    """

    # WHEN
    frag = gemtext_to_fragment(gemtext)

    # THEN
    assert floki_text(frag, "ul:nth-of-type(1) li") == [
             "item 1",
             "item 2",
             "item 3"
           ]

    assert floki_text(frag, "ul:nth-of-type(2) li") == [
             "item 1a",
             "item 1b"
           ]
  end

  test "blockquotes can be rendered" do
    # GIVEN
    gemtext = """
    > quote one
    > quote two
    """

    # WHEN
    frag = gemtext_to_fragment(gemtext)

    # THEN
    assert floki_text(frag, "blockquote:nth-of-type(1)") == ["quote one"]
    assert floki_text(frag, "blockquote:nth-of-type(2)") == ["quote two"]
  end

  test "text can be rendered" do
    # GIVEN
    gemtext = """
    paragraph one
    paragraph two

    paragraph three
    """

    # WHEN
    frag = gemtext_to_fragment(gemtext)

    # THEN
    assert floki_text(frag, "p:nth-of-type(1)") == ["paragraph one"]
    assert floki_text(frag, "p:nth-of-type(2)") == ["paragraph two"]
    assert floki_text(frag, "p:nth-of-type(3)") == ["paragraph three"]
  end

  test "preformatted text can be rendered" do
    # GIVEN
    gemtext = """
    ```
    def foo, do: bar
    ```

    ```elixir
    def flerb do
      :nerb
    end
    ```
    """

    # WHEN
    frag = gemtext_to_fragment(gemtext)

    # THEN
    assert floki_text(frag, "pre:nth-of-type(1)") == ["def foo, do: bar"]
    assert floki_text(frag, "pre:nth-of-type(2)") == ["def flerb do\n  :nerb\nend"]
  end
end
