defmodule BookshelfWeb.CustomStylesController do
  use BookshelfWeb, :controller

  alias Bookshelf.Books

  def index(conn, _params) do
    books = Books.create_book_structs()

    conn
    |> assign(:books, books)
    |> render(:index)
  end
end
