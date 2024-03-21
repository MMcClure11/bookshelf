defmodule BookshelfWeb.BasicDisplayController do
  use BookshelfWeb, :controller

  alias Bookshelf.Books

  def index(conn, %{"query" => query}) do
    conn
    |> assign(:books, Books.filter_books(query))
    |> assign(:query, query)
    |> render(:index)
  end

  def index(conn, _params) do
    conn
    |> assign(:books, Books.list_books())
    |> assign(:query, "")
    |> render(:index)
  end
end
