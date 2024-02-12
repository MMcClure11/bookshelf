defmodule BookshelfWeb.CustomStylesHTML do
  use BookshelfWeb, :html

  def index(assigns) do
    ~H"""
    <h1>The Bookshelf</h1>
    <p>Custom Styling</p>
    """
  end
end
