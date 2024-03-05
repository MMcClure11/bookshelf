defmodule BookshelfWeb.CustomStylesController do
  use BookshelfWeb, :controller

  alias Bookshelf.Books

  def index(conn, %{"query" => query}) do
    books = Books.filter_books(query)

    conn
    |> assign(:books, books)
    |> assign(:query, query)
    |> render(:index)
  end

  def index(conn, _params) do
    books = Books.create_book_structs()

    conn
    |> assign(:books, books)
    |> assign(:query, "")
    |> render(:index)
  end
end
