defmodule PoloniumTest do
  use ExUnit.Case
  doctest Polonium

  describe ".h/3" do
    test "outputs VDOM node for simple, single nodes" do
      vnode = Polonium.h("div")

      assert vnode == %Polonium.VNode{
               nodeName: "div",
               attributes: %{},
               children: [],
               key: nil
             }

      vnode = Polonium.h("div", %{class: "container"})

      assert vnode == %Polonium.VNode{
               nodeName: "div",
               attributes: %{"class" => "container"},
               children: [],
               key: nil
             }

      vnode = Polonium.h("div", %{"class" => "container"})

      assert vnode == %Polonium.VNode{
               nodeName: "div",
               attributes: %{"class" => "container"},
               children: [],
               key: nil
             }

      vnode = Polonium.h("div", class: "container")

      assert vnode == %Polonium.VNode{
               nodeName: "div",
               attributes: %{"class" => "container"},
               children: [],
               key: nil
             }
    end

    test "handles key attribute in a special way, copying it to 'key' field" do
      vnode = Polonium.h("div", class: "container", key: "key_1")

      assert vnode == %Polonium.VNode{
               nodeName: "div",
               attributes: %{"class" => "container", "key" => "key_1"},
               children: [],
               key: "key_1"
             }
    end

    test "should allow nested vnodes to be created" do
      vnode =
        Polonium.h("div", [class: "outer"], [
          "Inner Text",
          Polonium.h("div", class: "inner")
        ])

      assert vnode == %Polonium.VNode{
               nodeName: "div",
               attributes: %{"class" => "outer"},
               key: nil,
               children: [
                 "Inner Text",
                 %Polonium.VNode{
                   nodeName: "div",
                   attributes: %{"class" => "inner"},
                   children: [],
                   key: nil
                 }
               ]
             }

      vnode = Polonium.h("div", [], "I am not a list")

      assert vnode == %Polonium.VNode{
               nodeName: "div",
               children: [
                 "I am not a list"
               ]
             }
    end
  end

  test "should disallow invalid lists of children" do
    assert_raise RuntimeError, ~r/Unrecognized child/, fn ->
      Polonium.h("div", [], {:tuples, :are, :not, :expected, :here})
    end
  end

  test "should render to HTML" do
    vnode = %Polonium.VNode{
      nodeName: "div",
      attributes: %{"class" => "outer", "key" => "ignore"},
      key: "ignore",
      children: [
        "Inner Text",
        %Polonium.VNode{
          nodeName: "br",
          attributes: %{"class" => "inner"},
          children: [],
          key: nil
        }
      ]
    }

    {:safe, html} = Polonium.render(vnode)

    # TODO: fix this so that br is rendered to without closing tag
    assert Phoenix.HTML.safe_to_string({:safe, html}) ==
             "<div class=\"outer\">Inner Text<br class=\"inner\"></br></div>"
  end

  test "should compute diff of vnodes" do
    node_a = %Polonium.VNode{
      nodeName: "div",
      attributes: %{"class" => "outer"},
      children: ["This is vnode A"]
    }

    node_b = %Polonium.VNode{
      nodeName: "span",
      attributes: %{"class" => "inner"},
      children: ["This is vnode B"]
    }

    diff = Polonium.diff(node_a, node_b)

    assert diff == %{
             attributes: %{"class" => ["outer", "inner"]},
             children: %{
               "0" => ["This is vnode B"],
               "_0" => ["This is vnode A", 0, 0],
               "_t" => "a"
             },
             nodeName: ["div", "span"]
           }
  end
end
