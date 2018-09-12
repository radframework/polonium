defmodule Polonium.Helpers do
  import Polonium, only: [h: 3, h: 2]

  def div(attributes \\ %{}, children \\ []), do: h("div", attributes, children)
  def span(attributes \\ %{}, children \\ []), do: h("span", attributes, children)
  def a(attributes \\ %{}, children \\ []), do: h("a", attributes, children)
  def p(attributes \\ %{}, children \\ []), do: h("p", attributes, children)
  def i(attributes \\ %{}, children \\ []), do: h("i", attributes, children)
  def nav(attributes \\ %{}, children \\ []), do: h("nav", attributes, children)
  def textarea(attributes \\ %{}, children \\ []), do: h("textarea", attributes, children)
  def form(attributes \\ %{}, children \\ []), do: h("form", attributes, children)
  def ul(attributes \\ %{}, children \\ []), do: h("ul", attributes, children)
  def li(attributes \\ %{}, children \\ []), do: h("li", attributes, children)
  def table(attributes \\ %{}, children \\ []), do: h("table", attributes, children)
  def tr(attributes \\ %{}, children \\ []), do: h("tr", attributes, children)
  def td(attributes \\ %{}, children \\ []), do: h("td", attributes, children)
  def th(attributes \\ %{}, children \\ []), do: h("th", attributes, children)
  def header(attributes \\ %{}, children \\ []), do: h("header", attributes, children)

  def input(attributes \\ %{}), do: h("input", attributes)
  def button(attributes \\ %{}), do: h("button", attributes)
  def br(attributes \\ %{}), do: h("br", attributes)
  def hr(attributes \\ %{}), do: h("hr", attributes)
  def img(attributes \\ %{}), do: h("img", attributes)
  def iframe(attributes \\ %{}), do: h("iframe", attributes)
end
