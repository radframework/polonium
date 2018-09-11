defmodule PoloniumTest do
  use ExUnit.Case
  doctest Polonium

  describe ".h/3" do
    test "outputs VDOM node for simple, single nodes" do
      vnode = Polonium.h("div")

      assert vnode == %Polonium.VNode{
               node_name: "div",
               attributes: %{},
               children: [],
               key: nil
             }

      vnode = Polonium.h("div", %{class: "container"})

      assert vnode == %Polonium.VNode{
               node_name: "div",
               attributes: %{"class" => "container"},
               children: [],
               key: nil
             }

      vnode = Polonium.h("div", %{"class" => "container"})

      assert vnode == %Polonium.VNode{
               node_name: "div",
               attributes: %{"class" => "container"},
               children: [],
               key: nil
             }

      vnode = Polonium.h("div", class: "container")

      assert vnode == %Polonium.VNode{
               node_name: "div",
               attributes: %{"class" => "container"},
               children: [],
               key: nil
             }
    end

    test "handles key attribute in a special way, copying it to 'key' field" do
      vnode = Polonium.h("div", class: "container", key: "key_1")

      assert vnode == %Polonium.VNode{
               node_name: "div",
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
               node_name: "div",
               attributes: %{"class" => "outer"},
               key: nil,
               children: [
                 "Inner Text",
                 %Polonium.VNode{
                   node_name: "div",
                   attributes: %{"class" => "inner"},
                   children: [],
                   key: nil
                 }
               ]
             }

      vnode = Polonium.h("div", [], "I am not a list")

      assert vnode == %Polonium.VNode{
               node_name: "div",
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
end
