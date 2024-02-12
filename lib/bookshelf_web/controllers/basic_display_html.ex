defmodule BookshelfWeb.BasicDisplayHTML do
  use BookshelfWeb, :html

  def index(assigns) do
    ~H"""
    The Bookshelf
    """
  end
end
