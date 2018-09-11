defmodule Polonium do
  def h(node_name, attributes \\ %{}, children \\ [])

  def h(node_name, attributes, children) when not is_list(children) do
    h(node_name, attributes, [children])
  end

  def h(node_name, attributes, children)
      when is_binary(node_name) and (is_list(attributes) or is_map(attributes)) and
             is_list(children) do
    attributes = attributes |> Mappable.to_map(keys: :strings)

    %Polonium.VNode{
      node_name: node_name,
      attributes: attributes,
      children: validate_children(children),
      key: attributes["key"]
    }
  end

  defp validate_children(children) do
    Enum.each(children, &validate_child(&1))

    children
  end

  defp validate_child(%Polonium.VNode{} = _child), do: true
  defp validate_child(child) when is_binary(child), do: true
  defp validate_child(child) when is_number(child), do: true

  defp validate_child(child) do
    raise "Unrecognized child: #{inspect(child)}.\nSupported child types are: Polonium.VNode, string or number"
  end

  def render(%Polonium.VNode{} = vnode) do
    # TODO: fix this memory leak
    tag_name = String.to_atom(vnode.node_name)
    attributes = vnode.attributes |> Map.delete("key") |> Mappable.to_list()

    Phoenix.HTML.Tag.content_tag tag_name, attributes do
      render(vnode.children)
    end
  end

  def render(vnode) when is_list(vnode) do
    Enum.map(vnode, &render(&1))
  end

  def render(vnode) when is_binary(vnode), do: vnode
end
