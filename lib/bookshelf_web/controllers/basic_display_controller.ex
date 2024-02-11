defmodule BookshelfWeb.BasicDisplayController do
  use BookshelfWeb, :controller

  alias Bookshelf.Books

  def index(conn, _params) do
    conn = Plug.Conn.assign(conn, :books, Books.create_book_structs())
    render(conn, :index)
  end
end
